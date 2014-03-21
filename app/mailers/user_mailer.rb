class UserMailer < ActionMailer::Base
  default from: "noreply@inquestion.co.uk"
  layout 'email'
  def invite(email, user)
  	@email = email
  	@inviter = user
  	mail(to: @email, subject: "You've been invited to inquestion")
  end

end
