require 'test_helper'

class UpdatingUsersTest < ActionDispatch::IntegrationTest
	setup {
		@user = User.create!(
    	email: "testing@gmail.com",
    	password: "password",
    	name: "John Smith",
    	birthdate: Date.today - 21.years,
    	gender: "Male",
    	is_private: true,
    	bio: "I just wanna make friends. Please be my friend!"
    )
	}

	test 'Successful update' do
		patch "/users/#{@user.id}",
			{ user: { name: "Edited name" } }.to_json,
			{ "Accept" => Mime::JSON, "Content-Type" => Mime::JSON.to_s }

		assert_equal 200, response.status
		assert_equal "Edited name", @user.reload.name
	end

	test 'Unsuccesful update on name' do
		patch "/users/#{@user.id}",
			{ user: { name: "" } }.to_json,
			{ "Accept" => Mime::JSON, "Content-Type" => Mime::JSON.to_s }

		assert_equal 422, response.status
	end
end