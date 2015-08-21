class UsersController < ApplicationController
	# GET /users
	def index
		users = User.where(archived: false)
		render json: users, status: 200
	end

	# GET /users/:id
	def show
		user = User.find_unarchived(params[:id])
		render json: user, status: 200
	end

	# POST /users
	def create
		user = User.new(user_params)
		if user.save
			head 204, location: user
		else
			render json: user.errors, status: 422
		end
	end

	# PATCH /users/:id
	def update
		user = User.find_unarchived(params[:id])
		if user.update(user_params)
			render json: user, status: 200
		else
			render json: user.errors, status: 422
		end
	end

	# DELETE /users/:id
	def destroy
		user = User.find_unarchived(params[:id])
		user.archive
		head status: 204
	end

	def follow_user
		@user = set_user
		status = "following" if @user.is_public?
		status = "requested" if @user.is_private?
		@current_user.change_status(@user, status)
	end

	def unfollow_user
		@user = set_user
		@current_user.change_status(@user, "none")
	end

	private
		def set_user
			@user = User.find(params[:id])
		end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:event).permit(
      	:email,
      	:password,
      	:name,
      	:birthdate,
      	:gender,
      	:privacy,
      	:bio,
      	:image
      )
    end
end
