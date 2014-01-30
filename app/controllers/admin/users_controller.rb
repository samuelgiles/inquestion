class Admin::UsersController < Admin::AdminController

	def add
	end

	def index
	end

	def show

		@user = User.find(params[:id])

		respond_to do |format|

			format.json { render json: @user }

		end

	end

end
