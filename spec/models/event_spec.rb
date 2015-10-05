require 'rails_helper'

RSpec.describe Event, type: :model do
  context 'validations' do
    it 'has a valid factory' do
      expect(FactoryGirl.build(:event)).to be_valid
    end
  end
end