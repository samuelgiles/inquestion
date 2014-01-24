class Admin::AdminController < ApplicationController


	def index
	end

	before_filter :allowed?
	def allowed?
		current_user.admin
	end

end
