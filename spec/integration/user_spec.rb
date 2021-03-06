require 'rails_helper'

RSpec.describe '#Events' do

  before(:each) do
    @user = FactoryGirl.create(:user)
  end

  context 'creates an user' do
    it 'with email'
    it 'with facebook'
  end

  it 'updates an user' do
    data = {
      email: 'edited@email.com',
      name: 'Edited',
      birthdate: Date.today - 21.years,
      gender: "Female",
      bio: "Edited bio"
    }

    patch '/edit_profile', { user: data },
      { "Authorization" => "Token token=#{@user.auth_token}" }

    expect(response.status).to be 204

    expect(User.last.email).to eq(data[:email])
    expect(User.last.name).to eq(data[:name])
    expect(User.last.birthdate).to eq(data[:birthdate])
    expect(User.last.gender).to eq(data[:gender])
    expect(User.last.bio).to eq(data[:bio])
  end

  it 'deletes an user'
 
  context 'when updating password' do
    it 'updates succesfully' do
      post '/change_password', { password: '12345678', new_password: '87654321' },
        { "Authorization" => "Token token=#{@user.auth_token}" }

      expect(response.status).to be 204
      expect(User.last.authenticate('87654321')).to_not be false
    end
  
    it 'fails to update when old password is wrong' do
      post '/change_password', { password: 'wrong', new_password: '87654321' },
        { "Authorization" => "Token token=#{@user.auth_token}" }

      expect(response.status).to be 403
    end
  end

  context 'changes privacy' do
    it 'to public' do
      user = FactoryGirl.create(:user, is_private: false)
      post '/change_privacy', {},
        { "Authorization" => "Token token=#{user.auth_token}" }

      expect(User.last.is_private).to be true
    end

    it 'to private' do
      user = FactoryGirl.create(:user, is_private: true)
      post '/change_privacy', {},
        { "Authorization" => "Token token=#{user.auth_token}" }

      expect(User.last.is_private).to be false
    end
  end
end
