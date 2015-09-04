# == Schema Information
#
# Table name: assistants
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  event_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Assistant < ActiveRecord::Base
	belongs_to :user
	belongs_to :event

  after_create :notify_followers
  before_destroy :destroy_notifications

  validates_uniqueness_of :user_id, scope: [:event_id]

  private
    def notify_followers
      followers = User.find(user_id).followers
      followers.each do |follower|
        Feed.create(
          user: follower,
          event: event,
          feed_creator: user
        ) 
    	end
    end

    def destroy_notifications
      followers = User.find(user_id).followers
      followers.each do |follower|
        f = Feed.find_by(
          user: follower,
          event: event,
          feed_creator: user
        )
        f.destroy if f
      end
    end
end
