require 'rails_helper'

RSpec.describe 'login' do
  it 'returns 200 on successful login' do
    user = FactoryGirl.create(:user)
    post '/login', { email: user.email, password: '12345678' }
    expect(response.status).to be(200)
  end

  it 'returns correct data on successful login' do
    user = FactoryGirl.create(:user, email: 'esteban@email.com')
    post '/login', { email: user.email, password: '12345678' }

    response_data = JSON.parse(response.body)

    expect(response_data["name"]).to eq(user.name)
    expect(response_data["email"]).to eq(user.email)
    expect(Date.parse(response_data["birthdate"])).to eq(user.birthdate)
    expect(response_data["gender"]).to eq(user.gender)
    expect(response_data["is_private"]).to eq(user.is_private)
    expect(response_data["bio"]).to eq(user.bio)
  end

  it 'returns 401 on incorrect password' do
    user = FactoryGirl.create(:user)
    post '/login', { email: user.email, password: 'incorrect' }
    expect(response.status).to be(401)
  end

  it 'returns 401 on non-existing email' do
    user = FactoryGirl.create(:user)
    post '/login', { email: 'nonexisting@email.com', password: '12345678' }
    expect(response.status).to be(401)
  end

end
