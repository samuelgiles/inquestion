class Admin::UsersController < Admin::AdminController

	def add
	end

	def index
	end

	def show

		@user = User.find(params[:id])
		respond_to do |format|

			format.json { render json: @user.to_json(:methods => :last_seen_in_days) }

		end

	end

end
