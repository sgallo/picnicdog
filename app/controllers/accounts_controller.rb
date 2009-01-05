# This controller handles the login/logout function of the site.  
class AccountsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  
if RAILS_ENV == "production"
ssl_required :new, :add_email
end
 

  # render new.rhtml
  def new
    if logged_in?
      redirect_to :controller => "basket"
    end
    if request.post?
      self.current_user = User.authenticate(params[:login], params[:password])
      if logged_in?
        if params[:remember_me] == "1"
          current_user.remember_me unless current_user.remember_token?
          cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
        end
        render :update do |page|
          if session[:return_to] == nil
            page.redirect_to :controller => 'basket', :action => 'index'
          else
            page.redirect_to session[:return_to]
          end
        end
        flash[:notice] = "Logged in successfully"
      else
        render :update do |page|
          page.replace_html 'login_error', "Invalid Credentials"
        end
      end
    end
  end
 
  def create
    
  end
  
 
  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end
  
   def add_email
      
    e = Email.new(:email_address => params[:email][:email_address])
    e.save
    
    render :update do |page|
      page.replace_html "email", "<br>Thank you.  Your email has been submitted."
    end
  end

  def user_profile
    if current_user != nil
      @current_user = User.find(current_user.id, :include => [:profile])
    end 
  end
  
   def change_email
       return unless request.post?
       unless params[:email].blank? 
         current_user.change_email_address(params[:email]) 
         current_user.save
         @changed = true
       else
         flash[:notice] = "Please enter an email address" 
       end    
   end
   
   
  def forgot_password
    if request.xhr?
      if @user = User.find_by_email(params[:email])
        @user.forgot_password
        @user.save
        AccountMailer.deliver_forgot_password(@user) 
        #redirect_back_or_default(:controller => '/account', :action => 'index')
        render :update do |page|
          page.replace_html "message_box", "A password reset link has been sent to your email address" 
        end
      else
        render :update do |page|
          page.replace_html "message_box", "Email address not found in our system."
        end
      end
    end
  end
  
  def reset_password
   if request.xhr?
      @user = User.find_by_password_reset_code(params[:id])
      if @user != nil
        return if @user unless params[:password]
        if (params[:password] == params[:password_confirmation]) && (params[:password] != "")
          self.current_user = @user #for the next two lines to work
          current_user.password_confirmation = params[:password_confirmation]
          current_user.password = params[:password]
          @user.reset_password
          if current_user.save
            AccountMailer.deliver_reset_password(current_user) 
            render :update do |page|
              page.replace_html "message_box", "Password has been reset -  <a href='http://www.picnicdog.com'>Go to hompage</a>"
            end
          end
        else
          render :update do |page|
              page.replace_html "message_box", "Password mismatch or blank field"
          end
        end  
      else
        render :update do |page|
          page.replace_html "message_box", "Sorry.  That is an invalid password reset code. Please check your code and try again." 
        end
      end
   end
  end
  
end
