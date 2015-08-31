# == Schema Information
#
# Table name: feeds
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  event_id        :integer
#  feed_creator_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Feed < ActiveRecord::Base
	belongs_to :user, class_name: 'User', foreign_key: 'user_id'
	belongs_to :event, class_name: 'Event', foreign_key: 'event_id'
	belongs_to :feed_creator, class_name: 'User', foreign_key: 'feed_creator_id'

  def time_ago
    time_ago = Time.now - created_at

    minutes_ago = (time_ago / 60.minutes).round
    if minutes_ago < 60
      return "#{minutes_ago}m"
    else
      hours_ago = (time_ago / 1.hour).round
      if hours_ago < 24
        return "#{hours_ago}h"
      else
        days_ago = (time_ago / 1.day).round
        if days_ago < 7
          return "#{days_ago}d"
        else
          weeks_ago = (time_ago / 1.week).round
          return "#{weeks_ago}w"
        end
      end
    end
  end
end
