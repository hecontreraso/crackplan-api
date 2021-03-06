class NotificationsController < ApplicationController

  before_action :authenticate

  # GET /notifications
  def show
  	notifications = PublicActivity::Activity.order("created_at DESC").where("recipient_id = ?", 1)

  	notifications_to_return = []

    notifications.each do |notification|
    	notifications_to_return << Hash[
    		type: notification.key,
				owner: {
					id: notification.owner.id,
					name: notification.owner.name,
					image: notification.owner.image.small.url
				},
	      time_ago: time_ago(notification.created_at),
	      parameters: notification.parameters
    	]
    end
    render json: notifications_to_return, status: 200
  end

  # POST /notifications/:id/accept_request
	def accept_request
		user = set_user
		if user.requested?(@current_user)
			user.change_status(@current_user, "following")
			delete_request_notification(user)
			head 200
		end
	end

  # POST /notifications/:id/decline_request
	def decline_request
		user = set_user
		if user.requested?(@current_user)
			user.change_status(@current_user, "unfollowed")
			delete_request_notification(user)
			head 200
		end
	end

  private
		def delete_request_notification(user)
	    notification = PublicActivity::Activity.find_by(owner: user, recipient: @current_user, key: "follow.requested")
			notification.destroy
		end
end
