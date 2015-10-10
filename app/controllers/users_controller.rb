class UsersController < ApplicationController

	before_action :authenticate

	# POST /users
	def create
		user = User.new(user_params)
		if user.save
			head 204, location: user
		else
			render json: user.errors, status: 422
		end
	end

	# PATCH /edit_profile
	def update
		if @current_user.update(user_params)
			head 204
		else
			render json: @current_user.errors, status: 400
		end
	end

	# DELETE /users
	def destroy
		user = User.find_unarchived(params[:id])
		user.archive
		head status: 204
	end

	# POST /change_password
	def update_password
		if @current_user.authenticate(update_password_params[:password])
			@current_user.password = update_password_params[:new_password]
			@current_user.save!
			head 204
		else
			render json: 'Old password invalid', status: 403
		end
	end

	# POST /change_privacy
	def update_privacy
		if @current_user.change_privacy
			head 204
		else
			head 400
		end
	end

	private
    def user_params
			params.require(:user).permit(:email, :name, :birthdate, :gender, :bio)
		end

    def update_password_params
      params.permit(:password, :new_password)
    end

    def update_privacy_params
      params.permit(:is_private)
    end
end
