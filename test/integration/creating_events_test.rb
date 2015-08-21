require 'test_helper'

class CreatingEventsTest < ActionDispatch::IntegrationTest
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

	test 'creates event' do		
		post '/events',
			{ event:
				{
					creator: @user,
					details: "We are going to hang out with friends!",
					where: "Cinema Procinal in CC great station",
					date: Date.today + 3.days,
					time: Time.now - 5.hours
				}
			}.to_json,
			{
				'Accept' => Mime::JSON,
				'Content-Type' => Mime::JSON.to_s,
				'Authorization' => token_header(@user.auth_token)
			}

			assert_equal 201, response.status
			event = json(response.body)
			assert_equal event_url(event[:id]), response.location
	end
end
