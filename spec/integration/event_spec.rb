require 'rails_helper'

RSpec.describe '#Events' do
  # The feeds should display correctly. This is the test
  it 'shows' do
    user = FactoryGirl.create(:user)

    7.times do
      FactoryGirl.create(:event)
    end

    get '/events/0', {}, { "Authorization" => "Token token=#{user.auth_token}" }
    # response.body.to_json

    # expect(event.details).to eq(data[:details])
  end

  it 'creates a new event' do
    user = FactoryGirl.create(:user)

    data = {
      details: "Lorem ipsum sit amet",
      date: Date.today + 3.days,
      time: Time.new(2002, 10, 31, 19, 39, 20),
      where: "Really nice place",
      image: nil
    }
    post '/events', data, { "Authorization" => "Token token=#{user.auth_token}" }

    expect(response.status).to be(204)

    event = Event.last

    expect(event.details).to eq(data[:details])
    expect(event.date).to eq(data[:date])
    expect(event.time.hour).to eq(data[:time].hour)
    expect(event.time.min).to eq(data[:time].min)
    expect(event.time.sec).to eq(data[:time].sec)
    expect(event.where).to eq(data[:where])
  end

  it 'creator of and event adds a picture'
  it 'non-creator of an event try to add a picture'

  it 'user assists to a public event' do
    user = FactoryGirl.create(:user)
    event = FactoryGirl.create(:event)
    event.creator.is_private = false
    event.creator.save!

    post "/events/#{event.id}/toggle_assistance",
      {}, { "Authorization" => "Token token=#{user.auth_token}" }

    expect(response.status).to be 200

    response_data = JSON.parse(response.body)
    expect(response_data["user_is_going"]).to be true
  end

  it 'user assists to a private event (following the creator)' do
    user = FactoryGirl.create(:user)
    event = FactoryGirl.create(:event)
    user.change_status(event.creator, "following")

    post "/events/#{event.id}/toggle_assistance",
      {}, { "Authorization" => "Token token=#{user.auth_token}" }

    expect(response.status).to be 200

    response_data = JSON.parse(response.body)
    expect(response_data["user_is_going"]).to be true
  end

  it 'user try to assist to a private event (non-following the creator)' do
    user = FactoryGirl.create(:user)
    event = FactoryGirl.create(:event)

    post "/events/#{event.id}/toggle_assistance",
      {}, { "Authorization" => "Token token=#{user.auth_token}" }

    expect(response.status).to be 403
  end

  it 'user quits from an event' do
    user = FactoryGirl.create(:user)
    event = FactoryGirl.create(:event)
    user.change_status(event.creator, "following")
    user.assist(event)

    post "/events/#{event.id}/toggle_assistance",
      {}, { "Authorization" => "Token token=#{user.auth_token}" }

    expect(response.status).to be 200
    response_data = JSON.parse(response.body)
    expect(response_data["user_is_going"]).to be false
  end

  it 'user updates an event'
  it 'user deletes an event'  
end
