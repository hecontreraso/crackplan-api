class ProfileController < ApplicationController

  before_action do 
  	authenticate(true)
	end

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
		if @user.is_private?
			if user_signed_in?
				if @current_user.following?(@user)
					# render json: "PRIVATE, FOLLOWING USER"
					events = prepare_events(@user.created_events)
					render json: { profile_data: profile_data, events: events }, status: 200
				elsif @current_user.eql?(@user)
					# render json: "SAME USER PROFILE"
					events = prepare_events(@user.created_events)
					render json: { profile_data: profile_data, events: events }, status: 200
				else
					# render json: "PRIVATE, SIGNED IN, NOT FOLLOWING"
					render json: { profile_data: profile_data, events: "private" }, status: 200
					# Dont show any event
					# Show this profile is private message
				end
			else
				# render json: "PRIVATE, NOT SIGNED IN"
				# Dont show any event
				render json: { profile_data: profile_data, events: "private"}, status: 200
				# Show this profile is private message
			end
		else
			# render json: "SAME USER PROFILE"
			events = prepare_events(@user.created_events)
			render json: { profile_data: profile_data, events: events }, status: 200
		end
	end

	# POST /toggle_follow/:id
	def toggle_follow
		@user = set_user
		if @current_user.following?(@user) ||	@current_user.requested?(@user)
			status = "unfollowed"
			@current_user.change_status(@user, status)
			render json: { status: status }, status: 200
		else
			status = "following" if @user.is_public?
			status = "requested" if @user.is_private?
			@current_user.change_status(@user, status)
			render json: { status: status }, status: 200
		end
	end

	def accept_request
		@user = set_user
		if @user.requested?(@current_user)
			@user.change_status(@current_user, "following")
			head 204
		end
	end

	private
		def set_user
			@user = User.find_unarchived(params[:id])
		end

	  def prepare_events(events)
	    returned_events = []
	    
	    events.each do |event|
	    	is_going_to = @current_user.is_going_to?(event) if user_signed_in?
	    	
	    	event = Hash[
	    		id: event.id, #TODO include this?
					image: event.image.small.url,
					details: event.details,
		      assistants: event.get_visible_assistants(@current_user),
					where: event.where,
					date: event.date,
					time: event.time,
		      user_is_going: is_going_to
	    	]
	      returned_events << event
	    end
	    return returned_events
	  end
end
