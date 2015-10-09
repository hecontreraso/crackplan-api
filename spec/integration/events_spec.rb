# require 'rails_helper'

# RSpec.describe 'events' do
#   it 'get events with index 0' do
#     user = FactoryGirl.create(:user)
#     post '/login', { email: user.email, password: '12345678' }
#     expect(response.status).to be(200)
#   end

#   it 'returns 401 on incorrect password' do
#     user = FactoryGirl.create(:user)
#     post '/login', { email: user.email, password: 'incorrect' }
#     expect(response.status).to be(401)
#   end

#   it 'returns 401 on non-existing email' do
#     user = FactoryGirl.create(:user)
#     post '/login', { email: 'nonexisting@email.com', password: '12345678' }
#     expect(response.status).to be(401)
#   end

# end
