class UsersController < ApplicationController

	before_action :authenticate

	# GET /users
	# def index
	# 	users = User.where(archived: false)
	# 	render json: users, status: 200
	# end

	# GET /users/:id
	# def show
	# 	user = User.find_unarchived(params[:id])
	# 	render json: user, status: 200
	# end

	# POST /users
	# def create
	# 	user = User.new(user_params)
	# 	if user.save
	# 		head 204, location: user
	# 	else
	# 		render json: user.errors, status: 422
	# 	end
	# end

	# PATCH /edit_profile
	def update
		begin
			@current_user.update_attribute(:email, edit_user_params[:email])
			@current_user.update_attribute(:name, edit_user_params[:name])
			@current_user.update_attribute(:birthdate, edit_user_params[:birthdate])
			@current_user.update_attribute(:gender, edit_user_params[:gender])
			@current_user.update_attribute(:bio, edit_user_params[:bio])
			head 204
		rescue
			render json: @current_user.errors, status: 400
		end
	end

	# DELETE /users
	# def destroy
	# 	user = User.find_unarchived(params[:id])
	# 	user.archive
	# 	head status: 204
	# end

	# POST /follow/:id
	# def follow_user
	# 	@user = set_user
	# 	status = "following" if @user.is_public?
	# 	status = "requested" if @user.is_private?
	# 	@current_user.change_status(@user, status)
	# end

	# POST /unfollow/:id
	# def unfollow_user
	# 	@user = set_user
	# 	@current_user.change_status(@user, "none")
	# end

	# POST /change_password
	def change_password
		if @current_user.authenticate(change_password_params[:password])
			@current_user.password = change_password_params[:new_password]
			@current_user.save
			head 204
		else
			render json: 'Old password invalid', status: 403
		end
	end

	# POST /change_privacy
	def change_privacy
		if @current_user.update_attribute(
			:is_private,
			change_privacy_params[:is_private]
		)
			head 204
		else
			head 400
		end
	end

	private
		# def set_user
		# 	@user = User.find(params[:id])
		# end
    # Never trust parameters from the scary internet, only allow the white list through.
    def edit_user_params
			params.permit(:email, :name, :birthdate, :gender, :bio)
    end

    def change_password_params
      params.permit(:password, :new_password)
    end

    def change_privacy_params
      params.permit(:is_private)
    end
end
