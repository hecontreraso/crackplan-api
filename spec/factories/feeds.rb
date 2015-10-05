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

FactoryGirl.define do
  factory :feed do
    
  end

end
