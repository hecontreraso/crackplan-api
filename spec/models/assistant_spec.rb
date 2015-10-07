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

require 'rails_helper'

RSpec.describe Assistant, type: :model do
  context 'validations' do
    it 'has a valid factory' do
      expect(FactoryGirl.build(:assistant)).to be_valid
    end
  end
end
