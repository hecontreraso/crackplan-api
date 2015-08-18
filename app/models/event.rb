# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  details    :string           default(""), not null
#  where      :string           default(""), not null
#  date       :date             not null
#  time       :time
#  image      :string
#  creator_id :integer
#

class Event < ActiveRecord::Base

	has_many :assistants
	has_many :users, through: :assistants

	belongs_to :creator, class_name: "User", inverse_of: :created_events

  validates :details, presence: true
  validates :where, presence: true, length: { maximum: 150 }
  validates :date, 
    presence: true,
    timeliness: { 
      type: :date, 
      after: Date.today,
      after_message: "Events can only be created from tomorrow"
    }
	validates :creator_id, presence: true
	
	# Avatar uploader using carrierwave
  mount_uploader :image, EventImageUploader

  after_save :assist_to_event

  # Get all the assistants of an event that an specific user can see
  def get_visible_assistants(viewer_user)
    if viewer_user.nil? && creator.is_public?
      return users.where(is_private: false)
    elsif viewer_user.eql?(creator) # If I'm the creator, I can see all assistants
      return users
    # If I'm following the creator or the creator has a public profile, 
    # I can see all assistants but private and not following
    elsif (viewer_user.public_or_following_creator?(self))
      # TODO: ORDER THIS
      return users.collect { |user| 
        user if (user.is_public? || viewer_user.following?(user))
      }.compact
    end
  end

  def self.find_unarchived(id)
    find_by!(id: id, archived: false)
  end
  
  def archive
    self.archived = true
    self.save
  end

  ########################### DECORATORS ###########################
  

  # TODO deprecar estas jodas
  def friendly_date
    if date.eql?(Date.today)
      "Today"
    elsif date.eql?(Date.tomorrow)
      "Tomorrow"
    else
      date.strftime("%b %d")
    end
  end

  def friendly_hour
    time.strftime("%l:%M%P") unless time.nil?
  end

  private
  	#Add event creator to assistance list after creation
    def assist_to_event
      creator.assist(self)
    end

end
