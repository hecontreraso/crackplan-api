require 'test_helper'

class DeletingEventsTest < ActionDispatch::IntegrationTest
	setup { 
		@event = Event.create!(
			details: "We are going to hang out with friends!",
			where: "Cinema Procinal in CC great station",
			date: Date.today + 3.days,
			time: Time.now - 5.hours
    )
	}

	test 'Successful delete' do
		delete "/events/#{@event.id}"
		assert_equal 204, response.status
	end
end