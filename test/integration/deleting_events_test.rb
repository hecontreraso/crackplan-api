require 'test_helper'

class DeletingEventsTest < ActionDispatch::IntegrationTest
	setup {
		@user = Event.create!(
    	email: "testing@gmail.com",
    	password: "password",
    	name: "John Smith",
    	birthdate: Date.today - 21.years,
    	gender: "Male",
    	is_private: true,
    	bio: "I just wanna make friends. Please be my friend!"
		) 
		@event = Event.create!(
			creator: @user,
			details: "We are going to hang out with friends!",
			where: "Cinema Procinal in CC great station",
			date: Date.today + 3.days,
			time: Time.now - 5.hours
    )
	}

	test 'Successful delete' do
		delete "/events/#{@event.id}",
			{},
			{ 'Authorization' => token_header(@user.auth_token) }
		assert_equal 204, response.status
	end
end