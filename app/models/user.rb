# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  email              :string           default(""), not null
#  password_digest    :string           default(""), not null
#  created_at         :datetime
#  updated_at         :datetime
#  name               :string
#  birthdate          :date
#  gender             :string
#  is_private         :boolean
#  bio                :string
#  image              :string
#

class User < ActiveRecord::Base
  has_secure_password

  # A user can assist to many events
	has_many :assistants 
	has_many :events, through: :assistants

  # A user can create many events
	has_many :created_events, class_name: "Event",
    foreign_key: "creator_id", inverse_of: :creator

  # A user has feeds of his events
  has_many :feeds, inverse_of: :user

  # A user can follow another users
  has_many :follows, class_name: "Follow",
    foreign_key: "follower_id", dependent: :destroy

  has_many :following, through: :follows, source: :followed

  # A user have followers
  # has_many :follows, class_name: "Follow", foreign_key: "followed_id", dependent: :destroy
  # has_many :followers, through: :follows, source: :follower

	# Avatar uploader using carrierwave
  mount_uploader :image, UserImageUploader

  validates :email, presence: true, uniqueness: true, length: { maximum: 60 }
  validates :password, presence:true, confirmation: true, length: { minimum: 6 }
	validates :name, presence: true, length: { maximum: 30 }
	validates :birthdate,
    presence: true,
    timeliness: {
      type: :date, 
      before: Date.today,
      before_message: "The birthdate is incorrect"
    }
  validates :gender, presence: true, inclusion: [ "Male", "Female" ]
  validates :is_private, presence: true
	validates :bio, length: { maximum: 150 }

  #TODO FIX THIS ACCESOR AND MAKE ACTIVERECORD WORK
  def followers
    follower_ids = []
    Follow.where(followed_id: id, status: :following).each do |follow|
      follower_ids << follow.follower_id
    end
    User.where(id: follower_ids)
  end

  def follow_requests
    request_ids = []
    Follow.where(followed_id: id, status: :requested).each do |follow|
      request_ids << follow.follower_id
    end
    User.where(id: request_ids)
  end

  def future_events
    future_ev = []
    pre_future_events = events.where("date >= ?", Date.today)
    pre_future_events.each do |event| 
      future_ev << event if (event.date > Date.today || (event.date.eql?(Date.today) && event.time > Time.now) )        
    end
    future_ev
  end

  # Returns true if the current user is following the other user.
  def is_going_to?(event)
  	events.include?(event)
  end

  # TODO ver si puedo pasar los labels a angular 
  def get_going_label(event)
    relationship = Assistant.find_by(event_id: event.id, user_id: id)
    relationship.nil? ? "Join" : "Going"
  end

  def get_relationship_label(other_user)
    relationship = Follow.find_by(follower_id: id, followed_id: other_user.id)
    if relationship.nil?
      return "follow"
    else
      return relationship.status
    end
  end

  # TODO ver si puedo mover estas validaciones al controller y dejarlo sencillo
  # Request to join or quit from an event
  def toggle_assistance(event)
    if is_going_to?(event)
      Assistant.find_by(event_id: event.id, user_id: id).destroy
      return "Join"
    else
      if event.creator.is_public_profile?
        Assistant.create(event_id: event.id, user_id: id)
        return "Going"
      else
        if following?(event.creator)
          Assistant.create(event_id: event.id, user_id: id)
          return "Going"
        else
          return "Not permitted"
        end
      end
    end
  end 

  # TODO ver si puedo mover estas validaciones al controller y dejarlo sencillo
  # Attempts to follow or unfollow
  def toggle_follow(other_user)
    relationship = Follow.find_by(follower_id: id, followed_id: other_user.id)

    if relationship.nil? && other_user.is_public_profile?
      Follow.create(follower_id: id, followed_id: other_user.id, status: :following)
      return "following" 

    elsif relationship.nil? && other_user.is_private_profile?
      Follow.create(follower_id: id, followed_id: other_user.id, status: :requested)
      return "requested"

    elsif relationship.status.eql?("requested") || relationship.status.eql?("following")
      relationship.destroy
      return "follow"

    elsif relationship.status.eql?("blocked")
      return "user_is_blocked"
    end
  end

  # TODO ver si puedo mover estas validaciones al controller y dejarlo sencillo
  # Attempts to block or unblock
  def toggle_block(other_user)
    relationship = Follow.find_by(follower_id: id, followed_id: other_user.id)
    if relationship && relationship.status.eql?("blocked")
      relationship.destroy      
    elsif relationship
      relationship.status = :blocked
      relationship.save
    else
      Follow.create(follower_id: id, followed_id: other_user.id, status: :blocked)
    end
  end

  # TODO ver si puedo mover estas validaciones al controller y dejarlo sencillo
  def accept_follow_request(other_user)
    relationship = Follow.find_by(follower_id: other_user.id, followed_id: id)
    if relationship && relationship.status.eql?("requested")
      relationship.status = "following"
      relationship.save
    end
  end

  # TODO ver si puedo mover estas validaciones al controller y dejarlo sencillo
  def decline_follow_request(other_user)
    relationship = Follow.find_by(follower_id: other_user.id, followed_id: id)
    if relationship && relationship.status.eql?("requested")
      relationship.destroy
    end
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    Follow.find_by(follower_id: id, followed_id: other_user.id, status: :following)
  end

  # Returns true if the current user has requested to follow the other user.
  def requested?(other_user)
    Follow.find_by(follower_id: id, followed_id: other_user.id, status: :requested)
  end

  # Returns true if the current user has blocked the other user.
  def blocked?(other_user)
    Follow.find_by(follower_id: id, followed_id: other_user.id, status: :blocked)
  end

  def is_public_profile?
    !is_private
  end

  def is_private_profile?
    is_private
  end

  def self.find_unarchived(id)
    find_by!(id: id, archived: false)
  end

  def archive
    self.archived = true
    self.save
  end
end
