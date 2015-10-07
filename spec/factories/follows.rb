# == Schema Information
#
# Table name: follows
#
#  id          :integer          not null, primary key
#  follower_id :integer
#  followed_id :integer
#  status      :string
#

FactoryGirl.define do
  factory :follow do
    association :follower, factory: :user
    association :followed, factory: :user
    status 'following'

    trait :blocked do
 		  status 'blocked'
    end

    trait :requested do
 		  status 'requested'
    end

    trait :unfollowed do
 		  status 'unfollowed'
    end
  end
end
