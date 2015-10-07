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
  end
end
