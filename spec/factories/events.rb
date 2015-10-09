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

FactoryGirl.define do
  factory :event do
    details "Lorem ipsum dolor sit amet"
    where "Let's go to the beach"
    date Date.today + 3.days
    time Time.new(2002, 10, 31, 19, 30, 0)
    association :creator, factory: :user
  end
end
