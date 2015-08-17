require 'test_helper'

class CreatingUsersTest < ActionDispatch::IntegrationTest
	setup { host! 'api.example.com' }

	test 'creates user' do
		post '/users',
			{ user:
				{
	      	email: "testing@gmail.com",
	      	password: "password",
	      	name: "John Smith",
	      	birthdate: Date.today - 21.years,
	      	gender: "Male",
	      	is_private: true,
	      	bio: "I just wanna make friends. Please be my friend!"
				}
			}.to_json,
			{ 'Accept' => Mime::JSON, "Content-Type" => Mime::JSON.to_s }

			assert_equal 201, response.status
			assert_equal Mime::JSON, response.content_type

			user = json(response.body)
			assert_equal user_url(user[:id]), response.location
	end
end