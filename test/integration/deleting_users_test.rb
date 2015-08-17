require 'test_helper'

class DeletingUsersTest < ActionDispatch::IntegrationTest
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

	test 'Successful delete' do
		delete "/users/#{@user.id}"
		assert_equal 204, response.status
	end
end