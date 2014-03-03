class AnswersController < ApplicationController

	before_action :authenticate_user!, :only => [:create, :new, :myanswers, :accept, :unvote, :vote, :remove]

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

		end
		
	end

	def vote

		#Check to see if the user has voted or not already, need to send this back:
		@answer = Answer.find(params[:answer_id])
		@has_vote_from = Answer.where(:id => @answer.id).has_vote_from(current_user.id).length
		@voted = @has_vote_from > 0 ? true : false

		if @voted
			#unvote:
			AnswerVote.where(:answer_id => @answer.id).where(:user_id => current_user.id).delete_all
		else
			@answer.votes.create({:user_id => current_user.id})
		end

		respond_to do |format|

			format.json { render json: {success: true, voted: @voted, vote_count: @answer.votes.count} }

		end

	end

	#accept an answer
	def accept
		#check that the question owner is the same as the current user
			#mark as accepted
	end

	private
  	def answer_params
  		params.require(:answer).permit(:content)
  	end

end
