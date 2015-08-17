class UsersController < ApplicationController
	def index
		users = User.where(archived: false)
		render json: users, status: 200
	end

	def show
		user = User.find_unarchived(params[:id])
		render json: user, status: 200
	end

	def create
		user = User.new(user_params)
		if user.save
			head 204, location: user
		else
			render json: user.errors, status: 422
		end
	end

	def update
		user = User.find_unarchived(params[:id])
		if user.update(user_params)
			render json: user, status: 200
		else
			render json: user.errors, status: 422
		end
	end

	def destroy
		user = User.find_unarchived(params[:id])
		user.archive
		head status: 204
	end

	private
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
