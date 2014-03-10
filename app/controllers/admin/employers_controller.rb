class Admin::EmployersController < Admin::AdminController

	def new
		@employer = Employer.new
	end

	def create

		@employer = Employer.new
		@employer.name = params[:employer][:name]
		@employer.address = params[:employer][:address]
		@employer.phone = params[:employer][:phone]
		@employer.notes = params[:employer][:notes]

		if @employer.save
			redirect_to :new_admin_employer, :notice => "Employer successfully created"
		else
			render "new"
		end

	end

	def index
		@employers = Employer.order(:name)
	end

	def show

		@employer = Employer.find(params[:id])
		@apprentices = @employer.apprentices

	end

	respond_to :html, :json
	def update

		@employer = Employer.find(params[:id])
  		@employer.update_attributes(employer_params)
  		respond_with @employer

	end

	def destroy

		@employer = Employer.find(params[:id])
		@employer.apprentices.update_all(:employer_id => nil)
		@employer.destroy
		flash[:notice] = "Employer successfully removed"
		redirect_to :action => "index"

	end

	private
	  	def employer_params
	  		params.require(:employer).permit(:name, :address, :notes)
	  	end

end
