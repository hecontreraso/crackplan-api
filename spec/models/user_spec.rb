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

require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    it 'has a valid factory' do
      expect(FactoryGirl.build(:user)).to be_valid
    end
  
    describe '#email' do
		 	it { should validate_presence_of(:email) }
		 	it do 
		 		FactoryGirl.create(:user)
		 		should validate_uniqueness_of(:email)
		 	end
		 	it { should validate_length_of(:email).is_at_most(60) }
    end

    describe '#password' do
		 	it { should validate_presence_of(:password) }
		 	it { should validate_confirmation_of(:password) }
		 	it { should validate_length_of(:password).is_at_least(6) }
    end
  end

  describe '#name' do
	 	it { should validate_presence_of(:name) }
	 	it { should validate_length_of(:name)}
  end

  describe '#birthdate' do
	 	it { should validate_presence_of(:birthdate) }
  end

  describe '#gender' do
    it { should validate_presence_of(:gender) }
    it { should validate_inclusion_of(:gender).in_array(%w(Male Female)) }
  end

  describe '#bio' do
	 	it { should validate_length_of(:bio).is_at_most(150) }
  end
end
