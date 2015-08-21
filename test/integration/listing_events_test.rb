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

	test 'returns list of all events' do 
		get '/events', {}, { 'Authorization' => token_header(@user.auth_token) }
		assert response.success?
		assert_equal Mime::JSON, response.content_type
		refute_empty response.body
	end

	test 'returns event by id' do
		event = Event.create!(
			creator: @user,
			details: "This is the description of the event",
			where: "A very nice place",
			date: Time.now+3.days,
		) 
		get "/events/#{event.id}", 
			{},
			{ 'Authorization' => token_header(@user.auth_token) }
		assert response.success?
		assert_equal Mime::JSON, response.content_type
		event_response = json(response.body)
		assert_equal event.name, event_response[:name]
	end
end