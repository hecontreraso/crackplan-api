class LoginController < ApplicationController

  before_action only: [:logout] do 
  	authenticate(true)
	end

	# POST /login
	def login
		user = User.find_by(email: login_params[:email])
		if user = user.authenticate(login_params[:password])
			render json: user, status: 200
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
