class ProfileController < ApplicationController

  before_action :authenticate

	# GET /profile/:id
	def show
		@user = set_user

  	profile_data = Hash[
  		id: @user.id,
  		name: @user.name,
			image: @user.image.small.url,
			bio: @user.bio,
			events_qty: @user.created_events.count,
			followers_qty: @user.followers.count,
			following_qty: @user.following.count
  	]

		if @user.eql?(@current_user) || @user.is_public? || @current_user.following?(@user)
			profile_data['can_see_events'] = true
  	else
			profile_data['can_see_events'] = false
  	end

  	if profile_data['can_see_events']
			events = prepare_events(@user.created_events.order(date: :desc))
  	else
			events = nil
		end

		profile_data['status'] = @current_user.relationship_status(@user)
		
		render json: { profile_data: profile_data, events: events }, status: 200
	end

	def add_profile_pic
		if @current_user.update(image: set_profile_image[:image])
			head 204
		else
			head 400
		end
	end

	# POST /removeProfilePic
  def remove_profile_pic
  	@current_user.remove_image!
		@current_user.save
		head 204
  end

	# POST /toggle_follow/:id
	def toggle_follow
		user = set_user

		if @current_user.following?(user) || @current_user.requested?(user)
			can_see_events = false if user.is_private?
			@current_user.change_status(user, "unfollowed")
			render json: { status: "unfollowed", can_see_events: can_see_events }, status: 200
		else
			status = user.is_public? ? "following" : "requested" 
			can_see_events = status.eql?("following") ? true : false
			@current_user.change_status(user, status)
			render json: { status: status, can_see_events: can_see_events }, status: 200
		end
	end

	private
		def set_user
			user = User.find_unarchived(params[:id])
		end

  	def set_profile_image
			params.permit(:image)
		end

	  def prepare_events(events)
	    returned_events = []
	    
	    events.each do |event|
	    	event = Hash[
	    		id: event.id,
					image: event.image.small.url,
					details: event.details,
		      assistants: event.get_visible_assistants(@current_user),
					where: event.where,
					date: event.date,
					time: event.time,
		      user_is_going: @current_user.is_going_to?(event)
	    	]
	      returned_events << event
	    end
	    return returned_events
	  end
end
