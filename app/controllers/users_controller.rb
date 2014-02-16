class UsersController < ApplicationController

	def show

		@user = User.find(params[:id])
		@assessor_options = User.admins.collect{ |u| [u.id, u.full_name]}
		@assessor_options.unshift(["", "Unspecified"])

		@coordinator_options = User.coordinators.collect{ |u| [u.id, u.full_name]}
		@coordinator_options.unshift(["", "Unspecified"])

		@employer_options = User.coordinators.collect{ |u| [u.id, u.full_name]}
		@employer_options.unshift(["", "Yet to be assigned"])

		@keyskills_options = [["", "Unspecified"],["false", "Planned"],["true", "Exempt"]]

	end

	respond_to :html, :json
	def update

		@user = User.find(params[:id])
  		if current_user.is_admin || current_user.id == params[:id]
	  		@user.update_attributes(user_params)
	  		respond_with @user
  		end

	end

	def update_knowledge
		

		@user = User.find(params[:id])

		#check user has permission, could be replaced with cancan?
		if current_user.is_admin || current_user.id == params[:id]
			#Remove all knowledge, add via the new JSON
			@user.tags.delete_all

			params[:knowledge].each do |knowledgeArea|
				@user.tags.create(title: knowledgeArea)
			end

			respond_to do |format|

				format.json { render json: {success: params[:knowledge].length} }

			end
		end

	end

	def update_coordinator
		
	end

	def update_assessor

	end

	private
	  	def user_params
	  		params.require(:user).permit(:email, :notes, :assessor_id, :assessor, :employer, :coordinator_id, :employer_id, :start_date, :end_date, :english, :it, :maths)
	  	end

end
