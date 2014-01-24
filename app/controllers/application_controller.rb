class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
  	@userCount = User.count
  	@questionCount = Question.count
  	@answerCount = Answer.count
  end

  #Empty action just for a page full of every element on the site for CSS purposes
  def elements
  end

  def about
  end
  def terms
  end
  def privacy
  end

end
