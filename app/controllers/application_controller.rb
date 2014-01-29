class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_filter :configure_permitted_parameters, if: :devise_controller?
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

  def online_users
  @online_users ||= User.where('last_seen > ?', 5.minutes.ago).count
  end
  helper_method :online_users

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:assessor_user_id, :forename, :surname, :age, :employerName, :employerAddress]
    devise_parameter_sanitizer.for(:account_update) << :assessor_user_id
  end

end
