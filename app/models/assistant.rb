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
  include PublicActivity::Model

	belongs_to :user
	belongs_to :event

  after_create :add_feed_to_followers
  before_destroy :destroy_feed_from_followers

  validates_uniqueness_of :user_id, scope: [:event_id]

  private
    def add_feed_to_followers
      followers = User.find(user_id).followers
      followers.each do |follower|
        Feed.create(
          user: follower,
          event: event,
          feed_creator: user
        ) 
    	end
    end

    def destroy_feed_from_followers
      followers = User.find(user_id).followers
      followers.each do |follower| 
        f.destroy if Feed.find_by(user: follower, event: event, feed_creator: user )
      end
    end
end
