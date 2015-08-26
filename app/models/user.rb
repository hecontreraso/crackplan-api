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
  include ActiveModel::SecurePassword
  has_secure_password
  before_create :set_auth_token

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
  validates :is_private, inclusion: [ true, false ]
	validates :bio, length: { maximum: 150 }

  #TODO FIX THIS ACCESOR AND MAKE ACTIVERECORD WORK
  def followers
    follower_ids = Follow.where(followed: self, status: :following).collect(&:follower_id)
    User.where(id: follower_ids)
  end

  def public_or_following_creator?(event)
    following?(event.creator) || event.creator.is_public?
  end

  def follow_requests
    Follow.where(followed: self, status: :requested).collect(&:follower)
  end

  def relationship_status(other_user)
    relationship = Follow.find_by(follower: self, followed: other_user)
    relationship.status
  end

  def future_events
    events.where("date >= ? AND time > ?", Date.today, Time.now)
  end

  def is_going_to?(event)
    events.include?(event)
  end

  def assist(event)
    Assistant.create(event: event, user: self)
  end

  def quit(event)
    Assistant.create(event: event, user: self).destroy
  end

  def change_status(other_user, status)
    follow = Follow.find_or_create_by(follower: self, followed: other_user)  
    follow.update(status: status)
  end

  def decline_follow_request(other_user)
    Follow.find_by(follower: other_user, followed: self).destroy
  end

  # Defines the requested? following? and blocked? methods
  user_statuses = ["requested", "following", "blocked"]
  user_statuses.each do |status|
    User.send(:define_method, "#{status}?") do |other_user|
      Follow.exists?(follower: self, followed: other_user, status: user_statuses)
    end
  end

  def is_public?
    !is_private
  end

  def is_private?
    is_private
  end

  def self.find_unarchived(id)
    find_by!(id: id, archived: false)
  end

  def archive
    self.archived = true
    self.save
  end

  private

    def set_auth_token
      return if auth_token.present?
      self.auth_token = generate_auth_token
    end

    def generate_auth_token
      loop do
        token = SecureRandom.hex
        break token unless self.class.exists?(auth_token: token)
      end
    end
end
