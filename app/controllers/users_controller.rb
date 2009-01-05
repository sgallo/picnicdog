class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead

  # render new.rhtml
  def new
    
      check_valid_invite
     
  end

  def create
    if session[:invite]  
      cookies.delete :auth_token
      # protects against session fixation attacks, wreaks havoc with 
      # request forgery protection.
      # uncomment at your own risk
      # reset_session
      @user = User.new(params[:user])
      @user.time_zone = params[:user][:time_zone]
      Time.zone = @user.time_zone
      @user.save
      if @user.errors.empty?
        @profile = Profile.new(:user_id => @user.id)
        @profile.save
        invite = decrement_invite
        invite_list = InviteList.new(:user_id => @user.id, :invitation_id => invite.id)
        invite_list.save
        friend = User.find_by_login("sgallo")
        first_friend = Friendship.new(:user_id => @user.id, :friend_id => friend.id)
        first_friend.save
        self.current_user = @user
        begin
          AccountMailer.deliver_signup_thanks(current_user)
        rescue
          @user.invalid_email = 1
          @user.save
        end
        redirect_to :controller => "basket", :action => "index"
        flash[:notice] = "Thanks for signing up!"
      else
        render :action => 'new'
      end
    else
      #code if not session invite
    end
  end
  
  def no_invite
  end
  
  def spam
  end
  
  def change_email_address(new_email_address)
    @change_email  = true
    self.email = new_email_address
    #self.new_email = new_email_address
    #self.make_email_activation_code
   end

 
  private
  
  def decrement_invite
    #invite = Inviations.find(session[:invite])
    invite = Invitation.find(:first, :conditions => {:code => session[:invite].code})
    invite.count = invite.count - 1
    invite.save
    return invite
  end
  
  def check_valid_invite
    
    if params[:invite] != ""
      if invite = Invitation.find(:first, :conditions => {:code => params[:invite]})
        if invite.count <= 0
          redirect_to :controller => "users", :action => 'no_invite'
        else
          session[:invite] = invite
        end
      else
       redirect_to :controller => "users", :action => 'no_invite'
      end 
    end
  end
  

   
end
