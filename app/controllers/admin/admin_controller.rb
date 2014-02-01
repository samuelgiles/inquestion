class Admin::AdminController < ApplicationController

	def admin
		sum=0
		@questions_over_time = Question.group_by_day(:created_at).count.to_a.sort{|x,y| x[0] <=> y[0]}.map { |x,y| { x => (sum += y)} }.reduce({}, :merge)

		sum=0
		@answers_over_time = Answer.group_by_day(:created_at).count.to_a.sort{|x,y| x[0] <=> y[0]}.map { |x,y| { x => (sum += y)} }.reduce({}, :merge)
		

		@answeredQuestionCount = Question.answered.count
  		@unansweredQuestionCount = Question.unanswered.count

	end

	before_filter :allowed?
	def allowed?
		redirect_to(root_path) unless current_user.admin?
	end

end
