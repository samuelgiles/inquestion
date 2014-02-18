class UsersController < ApplicationController

	def show

		@user = User.find(params[:id])
		@assessor_options = User.admins.collect{ |u| [u.id, u.full_name]}
		@assessor_options.unshift(["", "Unspecified"])

		@coordinator_options = User.coordinators.collect{ |u| [u.id, u.full_name]}
		@coordinator_options.unshift(["", "Unspecified"])

		@employer_options = Employer.all.collect{ |u| [u.id, u.name]}
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
		
		@user = User.find(params[:user_id])
		#check user has permission, could be replaced with cancan?
		if current_user.is_admin || current_user.id == params[:user_id]

			if User.exists?(params[:user][:coordinator_id])
				@user.coordinator = User.find(params[:user][:coordinator_id])
			else
				@user.coordinator = nil
			end
			@user.save
			respond_with @user

		end

	end

	def update_assessor

		@user = User.find(params[:user_id])
		#check user has permission, could be replaced with cancan?
		if current_user.is_admin || current_user.id == params[:user_id]

			if User.exists?(params[:user][:assessor_id])
				@user.assessor = User.find(params[:user][:assessor_id])
			else
				@user.assessor = nil
			end
			@user.save
			respond_with @user

		end

	end

	respond_to :html, :json
	def update_employer

		@user = User.find(params[:user_id])
		#check user has permission, could be replaced with cancan?
		if current_user.is_admin || current_user.id == params[:user_id]

			if Employer.exists?(params[:user][:employer_id])
				@user.employer = Employer.find(params[:user][:employer_id])
			else
				@user.employer = nil
			end
			@user.save
			respond_with @user

		end

	end

	private
	  	def user_params
	  		params.require(:user).permit(:email, :notes, :assessor_id, :assessor, :employer, :coordinator_id, :employer_id, :start_date, :end_date, :english, :it, :maths)
	  	end

end
