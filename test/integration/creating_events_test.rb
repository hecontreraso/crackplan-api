require 'test_helper'

class CreatingEventsTest < ActionDispatch::IntegrationTest
	setup { host! 'api.example.com' }

	test 'creates event' do		
		post '/events',
			{ event:
				{
					details: "We are going to hang out with friends!",
					where: "Cinema Procinal in CC great station",
					date: Date.today + 3.days,
					time: Time.now - 5.hours
				}
			}.to_json,
			{ 'Accept' => Mime::JSON, "Content-Type" => Mime::JSON.to_s }

			assert_equal 201, response.status
			assert_equal Mime::JSON, response.content_type

			event = json(response.body)
			assert_equal event_url(event[:id]), response.location
	end
end