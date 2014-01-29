class Admin::QuestionsController < Admin::AdminController

	def new
		@question = Question.new
		@answer = @question.answers.build
	end

	def create

		@question = Question.new
		@question.title = params[:question][:title]
		@question.content = params[:question][:content]
		@question.user = current_user
		@question.save

		@answer = @question.answers.build
		@answer.content = params[:answer][:content]
		@answer.user = current_user
		@answer.accepted = true
		@answer.save

		redirect_to :new_admin_question, :notice => "Question + Answer successfully created"

	end

end