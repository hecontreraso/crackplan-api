require 'rails_helper'

RSpec.describe '#Profile' do

  before(:each) do
    @user = FactoryGirl.create(:user)
  end
  context 'when user access a public profile' do

    it 'shows profile data' do
      friend = FactoryGirl.create(:user, is_private: false)

      get "/profile/#{friend.id}", {}, { "Authorization" => "Token token=#{@user.auth_token}" }

      response_data = JSON.parse(response.body)

      expect(response_data['profile_data']['id']).to eq(friend.id)
      expect(response_data['profile_data']['name']).to eq(friend.name)
      expect(response_data['profile_data']['image']).to eq(friend.image.small.url)
      expect(response_data['profile_data']['bio']).to eq(friend.bio)
      expect(response_data['profile_data']['events_qty']).to eq(friend.created_events.count)
      expect(response_data['profile_data']['followers_qty']).to eq(friend.followers.count)
      expect(response_data['profile_data']['status']).to eq(nil)
      expect(response_data['profile_data']['can_see_events']).to be true
    end

    it 'shows events' do
      event = FactoryGirl.create(:event)
      event.creator.is_private = false
      event.creator.save!

      get "/profile/#{event.creator.id}", {}, { "Authorization" => "Token token=#{@user.auth_token}" }
      response_data = JSON.parse(response.body)

      expect(response_data['events'].last['id']).to eq(event.id)
      expect(response_data['events'].last['image']).to eq(event.image.small.url)
      expect(response_data['events'].last['details']).to eq(event.details)
      expect(response_data['events'].last['where']).to eq(event.where)
      expect(response_data['events'].last['user_is_going']).to eq(@user.is_going_to?(event))
    end
  end
   
  context 'when user access a private profile' do
    it 'shows profile data' do
      friend = FactoryGirl.create(:user, is_private: true)

      get "/profile/#{friend.id}", {}, { "Authorization" => "Token token=#{@user.auth_token}" }

      response_data = JSON.parse(response.body)

      expect(response_data['profile_data']['id']).to eq(friend.id)
      expect(response_data['profile_data']['name']).to eq(friend.name)
      expect(response_data['profile_data']['image']).to eq(friend.image.small.url)
      expect(response_data['profile_data']['bio']).to eq(friend.bio)
      expect(response_data['profile_data']['events_qty']).to eq(friend.created_events.count)
      expect(response_data['profile_data']['followers_qty']).to eq(friend.followers.count)
      expect(response_data['profile_data']['status']).to eq(nil)
      expect(response_data['profile_data']['can_see_events']).to be false
    end
  
    it 'doesn\'t show events (when not following them)' do
      friend = FactoryGirl.create(:user, is_private: true)

      get "/profile/#{friend.id}", {}, { "Authorization" => "Token token=#{@user.auth_token}" }
      response_data = JSON.parse(response.body)
      expect(response_data['events']).to be nil
    end
  
    it 'shows events (when following them)' do
      event = FactoryGirl.create(:event)
      
      @user.change_status(event.creator, "following")
      get "/profile/#{event.creator.id}", {}, { "Authorization" => "Token token=#{@user.auth_token}" }
      response_data = JSON.parse(response.body)
      expect(response_data['events']).to_not be nil
    end
  end

  it 'shows profile data from same user profile' do
    get "/profile/#{@user.id}", {}, { "Authorization" => "Token token=#{@user.auth_token}" }
    response_data = JSON.parse(response.body)

    expect(response_data['profile_data']['id']).to eq(@user.id)
    expect(response_data['profile_data']['name']).to eq(@user.name)
    expect(response_data['profile_data']['image']).to eq(@user.image.small.url)
    expect(response_data['profile_data']['bio']).to eq(@user.bio)
    expect(response_data['profile_data']['events_qty']).to eq(@user.created_events.count)
    expect(response_data['profile_data']['followers_qty']).to eq(@user.followers.count)
    expect(response_data['profile_data']['status']).to eq(nil)
    expect(response_data['profile_data']['can_see_events']).to be true
  end

  it 'adds current pic'
  it 'removes current pic'

  context 'when toggle follow' do
    it 'follows an user' do
      friend = FactoryGirl.create(:user, is_private: false)

      post "/profile/#{friend.id}/toggle_follow", {}, { "Authorization" => "Token token=#{@user.auth_token}" }
      response_data = JSON.parse(response.body)

      expect(response_data['status']).to eq("following")
      expect(response_data['can_see_events']).to eq(true)
    end

    it 'request to follow an user' do
      friend = FactoryGirl.create(:user, is_private: true)

      post "/profile/#{friend.id}/toggle_follow", {}, { "Authorization" => "Token token=#{@user.auth_token}" }
      response_data = JSON.parse(response.body)

      expect(response_data['status']).to eq("requested")
      expect(response_data['can_see_events']).to eq(false)
    end
  
    it 'unfollows a followed user' do
      friend = FactoryGirl.create(:user, is_private: true)
      @user.change_status(friend, "following")

      post "/profile/#{friend.id}/toggle_follow", {}, { "Authorization" => "Token token=#{@user.auth_token}" }
      response_data = JSON.parse(response.body)

      expect(response_data['status']).to eq("unfollowed")
      expect(response_data['can_see_events']).to eq(false)
    end
  
    it 'unfollows a requested user' do
      friend = FactoryGirl.create(:user, is_private: true)
      @user.change_status(friend, "requested")

      post "/profile/#{friend.id}/toggle_follow", {}, { "Authorization" => "Token token=#{@user.auth_token}" }
      response_data = JSON.parse(response.body)

      expect(response_data['status']).to eq("unfollowed")
      expect(response_data['can_see_events']).to eq(false)
    end
  end

end
