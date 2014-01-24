class Admin::QuestionsController < Admin::AdminController

	def new
		@question = Question.new
		@answer = @question.answers.build
	end

	def create
	end

end
