class EventsController < ApplicationController
	def index
		events = Event.where(archived: false)
		render json: events, status: 200
	end

	def show
		event = Event.find_unarchived(params[:id])
		render json: event, status: 200
	end

	def create
		event = Event.new(event_params)
		if event.save
			head 204, location: event
		else
			render json: event.errors, status: 422
		end
	end

	def update
		event = Event.find_unarchived(params[:id])
		if event.update(event_params)
			render json: event, status: 200
		else
			render json: event.errors, status: 422
		end
	end

	def delete
		event = Event.find_unarchived(params[:id])
		event.archive
		head status: 204
	end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:details, :where, :date, :time, :image)
    end

end
