class AccountMailer < ActionMailer::Base
  
  def signup_thanks( user )
    # Email header info MUST be added here
    recipients user.email
    from  "Picnic Dog <donotreply@picnicdog.com>"
    subject "Thank you for registering with our website"

    # Email body substitutions go here
    body :user=> user
  end

  def comment_posted( user, comment_user_name, meal_id )
    # Email header info MUST be added here
    recipients user.email
    from  "Picnic Dog - Comment <donotreply@picnicdog.com>"
    subject "Someone commented on one of your meals"

    # Email body substitutions go here
    body :user=> user, :comment_user_name => comment_user_name, :meal_id => meal_id
  end

   def comment_replied_to( user, comment_user_name, meal_id )
    # Email header info MUST be added here
    recipients user.email
    from  "Picnic Dog - Comment Reply <donotreply@picnicdog.com>"
    subject "Someone replied to a comment you particiated in"
    # Email body substitutions go here
    body :user=> user, :comment_user_name => comment_user_name, :meal_id => meal_id
  end

  def email_update( user )
    # Email header info MUST be added here
    recipients user.email
    from  "Picnic Dog <donotreply@picnicdog.com>"
    subject "Email Address Update"

    # Email body substitutions go here
    body :user=> user
  end
  
  def forgot_password(user)
    from  "Picnic Dog <support@picnicdog.com>"
    recipients user.email
    subject 'Request to change your password'
    body :user => user, :url => "http://www.picnicdog.com/accounts/reset_password/#{user.password_reset_code}"
  end

  def reset_password(user)
    from  "Picnic Dog <support@picnicdog.com>"
    recipients user.email
    subject 'Your password has been reset'
    body :user => user
  end
  
  def invite_sender(address, code, user)
    e = Email.new(:email_address => address)
    e.save
    from "Picnic Dog <support@picnicdog.com>"
    recipients address
    subject 'Picnic Dog Beta Invite'
    body :code => code, :user => user, :address => address
  end

  def mass_email(user)
    from "Picnic Dog <support@picnicdog.com>"
    recipients user.email
    subject 'Picnic Dog Message'
    body :user => user
  end
  
end
