class QuestionsController < ApplicationController
  
  def new

  	@question = Question.new

  end

  def create

  	@question = Question.new
  	@question.user = current_user
  	@question.update_attributes(question_params)
  	@question.save
  	redirect_to @question

  end

  def show

  	@question = Question.find(params[:id])
    @newAnswer = @question.answers.build

  end

  private
  	def question_params
  		params.require(:question).permit(:title, :content, :tag_list)
  	end

end
