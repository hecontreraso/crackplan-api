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

require 'rails_helper'

RSpec.describe Event, type: :model do
  context 'validations' do
    it 'has a valid factory' do
      expect(FactoryGirl.build(:event)).to be_valid
    end

	  describe '#details' do
		 	it { should validate_presence_of(:details) }
		 	it { should validate_length_of(:details).is_at_most(500) }
	  end

	  describe '#where' do
		 	it { should validate_presence_of(:where) }
		 	it { should validate_length_of(:where).is_at_most(150) }
	  end

	  describe '#date' do
	    it { should validate_presence_of(:date) }
	  end

	  describe '#creator' do
		 	it { should validate_presence_of(:creator_id) }
	  end

  end
end
