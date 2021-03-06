class EventsController < ApplicationController
	before_action :authenticate

	# Feed of events
	# GET /events/:index
  def index
		index = params[:index].to_i

    feeds = @current_user.feeds.order("created_at DESC").limit(2).offset(index)

    events = []
    feeds.each do |feed|
    	event = Hash[
    		id: feed.event.id,
				feed_creator: {
					id: feed.feed_creator.id,
					name: feed.feed_creator.name,
					image: feed.feed_creator.image.small.url
				},
	      hours_ago: time_ago(feed.created_at),
				image: feed.event.image.small.url,
				details: feed.event.details,
	      assistants: feed.event.get_visible_assistants(@current_user),
				where: feed.event.where,
				date: feed.event.date,
				time: feed.event.time,
	      user_is_going: @current_user.is_going_to?(feed.event),
				creator: {
					id: feed.feed_creator.id,
					name: feed.feed_creator.name
				}
    	]
      events << event
    end
		render json: events, status: 200
  end

	# POST /events
	def create
    event_params[:time] = event_params[:time].to_time if event_params[:time]
    event_params[:date] = event_params[:date].to_date
    event = Event.new(event_params)
    event.creator = @current_user

    if event.save!
			head 204
    else
			render json: event.errors, status: 422
    end
	end

	# POST /addEventPic
	def add_event_pic
		event = @current_user.created_events.last
		event.image = set_event_image[:image]
		if event.save!
			# head 204
			render json: "ok", status: 200
		else
			# head 400
			render json: "ERROR", status: 200
		end
	end
	# PATCH /events/:id
	# def update
	# 	event = Event.find_unarchived(params[:id])

	# 	if !@current_user.eql?(event.creator)
	# 		head 401
	# 		return
	# 	end

 #    if event.update(event_params)
	# 		render json: event, status: 200
 #    else
	# 		render json: event.errors, status: 422
 #    end
	# end

	# DELETE /events/:id
	# def delete
	# 	event = Event.find_unarchived(params[:id])
	# 	if !@current_user.eql?(event.creator)
	# 		head 401
	# 		return
	# 	end

	# 	event.archive
	# 	head status: 204
	# end

  # POST /events/:id/toggle_assistance
  def toggle_assistance
		event = set_event
  	if @current_user.is_going_to?(event)
			# CAN'T QUIT if the user is the event's creator
			if event.creator == @current_user
				head 403
			else
				@current_user.quit(event)
				render json: {user_is_going: false}, status: 200
			end
		else
			# CAN'T ASSIST if event is private and user is not following creator
			if event.creator.is_private? && !@current_user.following?(event.creator)
				head 403
			else
				@current_user.assist(event)
				render json: {user_is_going: true}, status: 200
			end
		end
  end

  private
    def set_event
      @event = Event.find_unarchived(params[:id])
    end

  	def set_event_image
			params.permit(:image)
		end

    def event_params
      params.permit(:details, :date, :time, :where, :image)
    end
end