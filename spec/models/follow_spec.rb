# == Schema Information
#
# Table name: follows
#
#  id          :integer          not null, primary key
#  follower_id :integer
#  followed_id :integer
#  status      :string
#

require 'rails_helper'

RSpec.describe Follow, type: :model do
  context 'validations' do
    it 'has a valid factory' do
      expect(FactoryGirl.build(:follow)).to be_valid
    end
  end
end
