require 'test_helper'

class ListingEventsTest < ActionDispatch::IntegrationTest
	setup {
		host! 'api.example.com'
		@user = Event.create!(
    	email: "testing@gmail.com",
    	password: "password",
    	name: "John Smith",
    	birthdate: Date.today - 21.years,
    	gender: "Male",
    	is_private: true,
    	bio: "I just wanna make friends. Please be my friend!"
		) 
	}

	test 'returns list of all users' do 
		get '/users', {}, { 'Authorization' => token_header(@user.auth_token) }
		assert response.success?
		assert_equal Mime::JSON, response.content_type
		refute_empty response.body
	end

	test 'returns user by id' do
		user = Event.create!(
			name: "Esteban Contreras",
			birthdate: Date.today-18.years,
			gender: "Male",
			is_private: true,
		) 
		get "/users/#{user.id}",
			{},
			{ 'Authorization' => token_header(@user.auth_token) }
		assert response.success?
		assert_equal Mime::JSON, response.content_type
		user_response = json(response.body)
		assert_equal user.name, user_response[:name]
	end

end