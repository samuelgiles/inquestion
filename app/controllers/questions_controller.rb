class QuestionsController < ApplicationController
  before_action :authenticate_user!, :only => [:create, :new, :myquestions]

  def new

  	@question = Question.new

  end

  def create

  	@question = Question.new
  	@question.user = current_user
  	@question.update_attributes(question_params)
  	if @question.save
      Inquestion::Application.config.twitter.update("#{current_user.forename} posted a question on inquestion #{url_for @question}}")
      redirect_to @question
    else
      render "new"
    end

  end

  def show

  	@question = Question.find(params[:id])
    @newAnswer = @question.answers.build

  end

  #show all the questions a user has asked
  def myquestions
  end

  #display all
  def index

    @popularQuestions = Question.all

  end

  private
  	def question_params
  		params.require(:question).permit(:title, :content, :tag_list)
  	end

end
