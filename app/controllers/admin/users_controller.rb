class Admin::UsersController < Admin::AdminController

	def add
	end

	def index

		#Assessor
		@assessorOption = params[:assessor_id]

		@assessor_options = User.admins.collect{ |u| [u.full_name, u.id]}
		@assessor_options.unshift(["All Assessors", "all"])
		@assessor_options.unshift(["Unspecified", "0"])

		if @assessorOption == "all" || @assessorOption == ""
			@apprentices = User.all
		elsif @assessorOption.to_i == 0
			@apprentices = User.where(assessor_user_id: nil)
		elsif @assessorOption.to_i > 0
			@assessor = User.find(@assessorOption)
			@apprentices = @assessor.assessor_students
		end

		@apprentices = @apprentices.order(:forename, :surname)

	end

	def show

		@user = User.find(params[:id])
		respond_to do |format|

			format.json { render json: @user.to_json(:methods => :last_seen_in_days) }

		end

	end

end
