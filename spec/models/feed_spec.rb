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

require 'rails_helper'

RSpec.describe Feed, type: :model do
  context 'validations' do
    it 'has a valid factory' do
      expect(FactoryGirl.build(:feed)).to be_valid
    end
  end
end
