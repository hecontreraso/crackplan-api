require 'test_helper'

class ListingEventsTest < ActionDispatch::IntegrationTest

	setup { host! 'api.example.com' }

	test 'returns list of all users' do 
		get '/users'
		assert response.success?
		refute_empty response.body
	end

	test 'returns user by id' do
		user = Event.create!(
			name: "Esteban Contreras",
			birthdate: Date.today-18.years,
			gender: "Male",
			is_private: true,
		) 
		get "/users/#{user.id}"
		assert response.success?

		user_response = json(response.body)
		assert_equal user.name, user_response[:name]
	end

end