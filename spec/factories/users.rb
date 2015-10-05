# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  name            :string           not null
#  birthdate       :date             not null
#  gender          :string           not null
#  is_private      :boolean          default(FALSE), not null
#  bio             :string           default(""), not null
#  archived        :boolean          default(FALSE), not null
#  auth_token      :string
#  image           :string
#  created_at      :datetime
#  updated_at      :datetime
#

FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password '12345678'
    name "Stephen"
    birthdate Date.today - 20.years
    gender "Male"
    is_private true
    bio "Lorem ipsum sit dolor din amet"
  end
end
