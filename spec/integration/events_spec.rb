require 'rails_helper'

RSpec.describe 'events' do
  it 'creates a new event' do
    user = FactoryGirl.create(:user)
    post '/login', { email: user.email, password: '12345678' }
    response_data = JSON.parse(response.body)
    data = {
      details: "Lorem ipsum sit amet",
      date: Date.today + 3.days,
      time: Time.new(2002, 10, 31, 19, 39, 20),
      where: "Really nice place",
      image: nil
    }
    post '/events', data, {
      "Authorization" => "Token token=#{response_data['auth_token']}"
    }

    expect(response.status).to be(204)

    event = Event.last

    expect(event.details).to eq(data[:details])
    expect(event.date).to eq(data[:date])
    expect(event.time.hour).to eq(data[:time].hour)
    expect(event.time.min).to eq(data[:time].min)
    expect(event.time.sec).to eq(data[:time].sec)
    expect(event.where).to eq(data[:where])
  end

  it 'returns 401 on non-existing email' do
    user = FactoryGirl.create(:user)
    post '/login', { email: 'nonexisting@email.com', password: '12345678' }
    expect(response.status).to be(401)
  end

end
