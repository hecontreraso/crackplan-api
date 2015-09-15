# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  details    :string           not null
#  where      :string           not null
#  date       :date             not null
#  time       :time
#  image      :string
#  creator_id :integer          not null
#  archived   :boolean          default(FALSE), not null
#  created_at :datetime
#  updated_at :datetime
#

class Event < ActiveRecord::Base
	
  has_many :assistants
	has_many :users, through: :assistants

	belongs_to :creator, class_name: "User", inverse_of: :created_events

  validates :details, presence: true, length: { maximum: 500 }
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

  after_create :assist_to_event

  # Get all the assistants of an event that an specific user can see
  # 1. If I'm the creator, I can see all assistants
  # 2. If I'm following the creator or the creator has a public profile, 
  # I can see all assistants but private and not following
  def get_visible_assistants(viewer_user)
    if viewer_user.nil? && creator.is_public?
      user_list = users.where(is_private: false)
    elsif viewer_user.eql?(creator)
      user_list = users
    elsif (viewer_user.public_or_following_creator?(self))
      # TODO: ORDER THIS
      user_list = users.collect { |user| 
        user if (user.is_public? || viewer_user.following?(user))
      }.compact
    end

    # Removing unnecesary data. Leaving just name and id
    assistant_list = []
    user_list.each{ |assistant|
      assistant_list << Hash[id: assistant.id, name: assistant.name]
    }
    return assistant_list
  end

  def self.find_unarchived(id)
    find_by!(id: id, archived: false)
  end
  
  def archive
    self.archived = true
    self.save
  end

  private
  	#Add event creator to assistance list after creation
    def assist_to_event
      creator.assist(self)
    end
end
