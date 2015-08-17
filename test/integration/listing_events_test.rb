require 'test_helper'

class ListingEventsTest < ActionDispatch::IntegrationTest

	setup { host! 'api.example.com' }

	test 'returns list of all events' do 
		get '/events'
		assert response.success?
		refute_empty response.body
	end

	test 'returns event by id' do
		user = Event.create!(
			name: "Esteban Contreras",
			birthdate: Date.today-18.years,
			gender: "Male",
			privacy: "private",
		) 
		event = Event.create!(
			creator: user,
			details: "This is the description of the event",
			where: "A very nice place",
			date: Time.now+3.days,
		) 
		get "/events/#{event.id}"
		assert response.success?

		event_response = json(response.body)
		assert_equal event.name, event_response[:name]
	end

end