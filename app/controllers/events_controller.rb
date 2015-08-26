class EventsController < ApplicationController
	before_action :authenticate

	# GET /events
  def index
		# events = Event.where(archived: false) TODO revisar eventos archivados
    feeds = @current_user.feeds.sort_by(&:created_at).reverse 
    
    rendered_events = []

    feeds.collect do |feed|
      rendered_event = RenderedEvent.new

      rendered_event.event_id = feed.event.id
      rendered_event.feed_creator = feed.feed_creator
      rendered_event.image = feed.event.image
      rendered_event.creator = feed.event.creator
      rendered_event.details = feed.event.details
      rendered_event.where = feed.event.where
      rendered_event.date = feed.event.date
      rendered_event.time = feed.event.time
      
      rendered_event.hours_ago = ((Time.now - feed.created_at) / 1.hour).round
      rendered_event.assistants = feed.event.get_visible_assistants(@current_user)
      rendered_event.is_going = @current_user.is_going_to?(feed.event)

      rendered_events << rendered_event
    end
		render json: rendered_events, status: 200
  end

	# GET /events/:id
	# def show
		# que solo pueda ver eventos propios
		# event = Event.find_unarchived(params[:id])
		# render json: event, status: 200
	# end

	# POST /events
	def create
    event_params[:time] = event_params[:time].to_time

    event = Event.new(event_params)
    event.creator = current_user

    if event.save
			head 204, location: event
    else
			render json: event.errors, status: 422
     end
	end

	# PATCH /events/:id
	def update
		event = Event.find_unarchived(params[:id])

		if !@current_user.eql?(event.creator)
			head 401
			return
		end

    if event.update(event_params)
			render json: event, status: 200
    else
			render json: event.errors, status: 422
    end
	end

	# DELETE /events/:id
	def delete
		event = Event.find_unarchived(params[:id])
		
		if !@current_user.eql?(event.creator)
			head 401
			return
		end

		event.archive
		head status: 204
	end

  # POST /events/:id/toggle_assistance
  def toggle_assistance
		event = set_event
		returned_value = ""

		if @current_user.is_going_to?(event)
			@current_user.quit(event)
			returned_value = "assistance removed"
		else
			@current_user.assist(event)
			returned_value = "assistance added"
		end

    render json: { returned_state: returned_value }
  end

  private
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:details, :where, :date, :time, :image)
    end
end
