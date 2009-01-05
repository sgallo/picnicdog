# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include HoptoadNotifier::Catcher
  include SslRequirement
  before_filter :set_time_zone
 
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  #protect_from_forgery :secret => '1b07f04adb089669933bf500c5dd1700'
  
  def go_basket
    if logged_in?
      redirect_to :controller => "basket", :action => "index"
    end
  end
  
  def set_time_zone
    Time.zone = current_user.time_zone if current_user
  end

  
  protected
   
  def check_comment_for_spam(author, text)
    @akismet = Akismet.new('4773bb27cc0c', 'http://www.picnicdog.com') # blog url: e.g.

    # return true when API key isn't valid, YOUR FAULT!!
    return true unless @akismet.verifyAPIKey 

    # will return false, when everthing is ok and true when Akismet thinks the comment is spam. 
    return @akismet.commentCheck(
             request.remote_ip,            # remote IP
             request.user_agent,           # user agent
             request.env['HTTP_REFERER'],  # http referer
             '',                           # permalink
             'comment',                    # comment type
             author,                       # author name
             '',                           # author email
             '',                           # author url
             text,                         # comment text
             {})                           # other
  end
  
end
