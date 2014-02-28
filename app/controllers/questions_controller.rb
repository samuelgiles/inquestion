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
      #Randomly post questions on twitter
      if rand(6) > 3
        TwitterClient.update("#{current_user.forename} posted a question on inquestion #{url_for @question}")
      end
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

    #sort types:
    #popular : questions measured by the number of answers in the last 6 weeks (this could change is service is popular)
    #new : questions by created_at
    #recently answered : get questions sorted by updated_at with accepted answers (touch question on accept answer)
    
    if params.has_key?(:new)
      @sort_title = "New Questions"
      @questions = Question.order(:created_at).limit(10)
    elsif params.has_key?(:answered)
      @sort_title = "Answered Questions"
      @questions = Question.answered.order(:updated_at).limit(10)
    else
      @sort_title = "Popular Questions"
      @questions = Question.popular.limit(10)
    end

  end

  def vote

    #Check to see if the user has voted or not already, need to send this back:
    @question = Question.find(params[:question_id])
    @has_vote_from = Question.where(:id => @question.id).has_vote_from(current_user.id).length
    @voted = @has_vote_from > 0 ? true : false

    if @voted
      #unvote:
      Vote.where(:question_id => @question.id).where(:user_id => current_user.id).delete_all
    else
      Vote.create({:question_id => @question.id, :user_id => current_user.id})
    end

    respond_to do |format|

      format.json { render json: {success: true, voted: @voted, vote_count: @question.votes.count} }

    end

  end

  private
  	def question_params
  		params.require(:question).permit(:title, :content, :tag_list)
  	end

end
