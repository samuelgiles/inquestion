class AnswersController < ApplicationController

	#don't think there is a new...
	def new

	end
	
	#question answer
	def create

		#load question
		@question = Question.find(params[:question_id]);

		if @question != nil 

			@answer = @question.answers.build
		  	@answer.user = current_user
		  	@answer.update_attributes(answer_params)
		  	@answer.save

			redirect_to @question
		else
			#question not found?
		end
		
	end

	#removes answer, deletes any references to it (comments)
	def remove

	end

	#add vote to answer as the current_user
	def vote

	end

	#remove vote from answer for the current_user
	def unvote

	end

	#accept an answer
	def accept
		#check that the question owner is the same as the current user
			#mark as accepted
	end

	#show all the questions a user has answered
	def myanswers
	end

	private
  	def answer_params
  		params.require(:answer).permit(:content)
  	end

end
