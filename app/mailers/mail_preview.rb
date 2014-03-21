  class MailPreview < MailView
    
    def invite
      
		UserMailer.invite("sam@samuelgil.es", User.find(1))

    end

  end