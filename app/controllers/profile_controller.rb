class ProfileController < ApplicationController

  before_action do 
  	authenticate(true)
	end

	# GET /profile/:id
	def show
		@user = set_user

		if @user.is_private?
			if user_signed_in?
				if @current_user.following?(@user)
					render json: "PRIVATE, SIGNED IN, FOLLOWING"
				elsif @current_user.eql?(@user)
					render json: "PRIVATE, SIGNED IN, SAME USER"
				else
					render json: "PRIVATE, SIGNED IN, NOT FOLLOWING"
				end
			else
				render json: "PRIVATE, NOT SIGNED IN"
			end
		else
			if user_signed_in?
				if @current_user.eql?(@user)
					render json: "PUBLIC, SIGNED IN, SAME USER"
				end
			else
				render json: "PUBLIC, NOT SAME USER"
			end
		end
	end

	private
		def set_user
			@user = User.find(params[:id])
		end
end