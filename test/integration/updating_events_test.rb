require 'test_helper'

class UpdatingEventsTest < ActionDispatch::IntegrationTest
	setup { 
		@event = Event.create!(
			details: "We are going to hang out with friends!",
			where: "Cinema Procinal in CC great station",
			date: Date.today + 3.days,
			time: Time.now - 5.hours
    )
	}

	test 'Succesful update' do
		patch "/events/#{@event.id}",
			{ event: { details: "Edited details" } }.to_json,
			{ "Accept" => Mime::JSON, "Content-Type" => Mime::JSON.to_s }

		assert_equal 200, response.status
		assert_equal "Edited details", @event.reload.details
	end

	test 'Unsuccessful update on details' do
		patch "/events/#{@event.id}",
			{ event: { details: "" } }.to_json,
			{ "Accept" => Mime::JSON, "Content-Type" => Mime::JSON.to_s }

		assert_equal 422, response.status
	end

end