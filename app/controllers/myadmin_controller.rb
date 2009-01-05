class MyadminController < ApplicationController
  USER_NAME, PASSWORD = "pd1234", "contour1234"
  before_filter :authenticate

  def index

    
  end


  def email
     @emails = Email.paginate(:all, :page => params[:page], :per_page => 500 )
  end

  def users
    @users = User.paginate(:all, :include => [:profile], :page => params[:page], :per_page => 500 )
  end

  def mass_mail
    @users = User.find(:all, :include => [:profile])
    @users.each do |user|
      if user.profile.send_system_email == 0
        AccountMailer.deliver_mass_email(user)
      end
    end
    flash[:notice] = "Emails Sent"
    redirect_to :action => "index"
  end

  private
  def authenticate
    authenticate_or_request_with_http_basic do |user_name, password|
      user = User.find(current_user)
      user_name == USER_NAME && password == PASSWORD && (user.login == 'sgallo')
    end
  end

end
