class NotificationsController < ApplicationController

	def clear

		#pass in a collection of notifications that the user has marked to clear, mark them as seen:
		notifications_to_clear = params["notifications"]
		notifications_to_clear.each do |notification_id|

			notification_to_clear = current_user.notifications.unseen.find(notification_id)
			if notification_to_clear != nil
				notification_to_clear.seen = true
				notification_to_clear.save
			end

		end

		respond_to do |format|

			format.json { render json: {success: true} }

		end

	end

	def index

		@notifications = current_user.notifications.unseen
		if params["js"] == "true"
			render :layout => false
		else
			#TODO: Redirect to notifications area of profile page
			render :layout => true
		end

	end

	#user polls this, javascript checks for difference in notification seen count
	def check

		@unseenNotifications = {notifications: current_user.notifications.unseen.count}
		respond_to do |format|

			format.json { render json: @unseenNotifications }

		end

	end

end
