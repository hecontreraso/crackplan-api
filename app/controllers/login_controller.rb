class LoginController < ApplicationController

	# POST /login
	def login
		user = User.find_by(email: login_params[:email])

		if user.nil?
			render json: "Bad credentials", status: 401
		elsif user = user.authenticate(login_params[:password])
			render json: {
				auth_token: user.auth_token,
				id: user.id,
				email: user.email,
				fullName: user.name,
				birthdate: user.birthdate,
				gender: user.gender,
				is_private: user.is_private,
				bio: user.bio,
				image: user.image.small.url
			}, status: 200
		else
			render json: "Bad credentials", status: 401
		end
	end

	private
    # Never trust parameters from the scary internet, only allow the white list through.
    def login_params
      params.permit(:email, :password)
    end
end