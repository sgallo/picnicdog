ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
   :address => "picnicdog.com", # => EXTERNAL SMTP HOST
   :port => 25,
   :domain => "picnicdog.com",
   :authentication => :plain,
   :user_name => "support",
   :password => "contour1"
 }