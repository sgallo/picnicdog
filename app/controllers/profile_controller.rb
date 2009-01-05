class ProfileController < ApplicationController
require 'digest/sha1'
require 'RMagick'
before_filter :login_required
  def index
    @profile = load_profile 
    @user = User.find(current_user)
  end
  
  def update_profile
    @profile = Profile.find_by_user_id(current_user.id)
    @profile.full_name = params[:profile][:full_name]
    @profile.about = params[:profile][:about]
    @profile.location = params[:profile][:location]
    
    if @profile.save
      render :update do |page|
        page.replace_html "profile_error", "Your Profile has been Updated"
        page.replace_html "profile_box", :partial => "accounts/user_profile"
        page.show "profile_error"
      end
    else
      render :update do |page|
        page.replace_html "profile_error", "Error Saving Profile"
        page.show "profile_error"
      end
    end 
  end
  
  def update_email
    @user = current_user
    @user.email = params[:email]
    if @user.save
      begin
        AccountMailer.deliver_email_update(@user)
        @user.invalid_email = 0
        @user.save
      rescue
          @user.invalid_email = 1
          @user.save
      end

      render :update do |page|
        page.replace_html "email_error", "Your email address has been updated"
        page.replace_html "profile_box", :partial => "accounts/user_profile"
        page.show "email_error"
      end
    else
      render :update do |page|
        page.replace_html "email_error", "Error Saving Email Address..might already exist?"
        page.show "email_error"
      end
    end 
  end
  
  def update_twitter
    @user = current_user
    twitter = Twitter::Client.new
    if params[:twitter_active] != nil
      begin
        if twitter.authenticate?(params[:twitter_username], params[:twitter_password])
          @user.profile.twitter_username = params[:twitter_username]
          @user.profile.twitter_password = params[:twitter_password]
          @user.profile.twitter_active = true
          if @user.profile.save
            render :update do |page|
              page.replace_html "twitter_error", "Your Twitter information has been updated"
              page.show "twitter_error"
            end
          else
            render :update do |page|
              page.replace_html "twitter_error", "Error Saving Twitter Information!"
              page.show "twitter_error"
            end
          end
        end
      rescue
        render :update do |page|
          page.replace_html "twitter_error", "Could not connect to twiiter"
          page.show "twitter_error"
        end
      end
    else
      @user.profile.twitter_active = false
      if @user.profile.save
        render :update do |page|
          page.replace_html "twitter_error", "Your Twitter information has been updated"
          page.show "twitter_error"
        end
      end
    end
  end

  def update_private
    @user = current_user
    if params[:private] != nil
      @user.profile.private = true else @user.profile.private = false
    end
    if @user.profile.save
      render :update do |page|
        page.replace_html "private_error", "Your privacy information has been updated"
        page.show "private_error"
      end
    else
      render :update do |page|
        page.replace_html "private_error", "Error Saving Privacy Information!"
        page.show "private_error"
         #page.visual_effect :fade, "private_error", :duration => 3
      end
    end
  end

  def update_comments
    @user = current_user
    if params[:comments] != nil
      @user.profile.send_comments = true else @user.profile.send_comments = false
    end
    if @user.profile.save
      render :update do |page|
        page.replace_html "comment_error", "Your comment information has been updated"
        page.show "comment_error"
      end
    else
      render :update do |page|
        page.replace_html "comment_error", "Error Saving Comment Setting!"
        page.show "comment_error"
      end
    end
  end

  def update_system_email
    @user = current_user
    if params[:send_system_email] != nil
      @user.profile.send_system_email = true else @user.profile.send_system_email = false
    end
    if @user.profile.save
      render :update do |page|
        page.replace_html "system_email_error", "Your System Email setting has been updated"
        page.show "system_email_error"
      end
    else
      render :update do |page|
        page.replace_html "system_email_error", "Error Saving Email Setting!"
        page.show "system_email_error"
      end
    end
  end
  
  def update_timezone
    @user = current_user
    @user.time_zone = params[:time_zone]
    if @user.save
      render :update do |page|
        page.replace_html "timezone_error", "Your Timezone has been Updated"
        page.replace_html "profile_box", :partial => "accounts/user_profile"
        page.show "timezone_error"
      end
    else
      render :update do |page|
        page.replace_html "timezone_error", "Error Saving Timezone"
        page.show "timezone_error"
      end
    end 
  end
  
  def changepassword
    if request.post?
      flash[:notice]= ""
      flash[:error]= ""
      if current_user.authenticated?(params[:old_password])
        current_user.password = params[:password]
        current_user.password_confirmation = params[:password_confirmation]
        begin
          current_user.save!
          render :update do |page|
            page.replace_html "password_error", "Successfully changed your password."
            page.show "password_error"
          end
          
        rescue ActiveRecord::RecordInvalid => e
          render :update do |page|
            page.replace_html "password_error", "Couldn't change your password: #{e}"
            page.show "password_error"
          end
          
        end
      else
        render :update do |page|
            page.replace_html "password_error","Couldn't change your password: is that really your current password?" 
            page.show "password_error"
          end
    
      end
    end
  end 
  
  def update_mug
  
    @status_text = "Problem saving image"
    if (@profile = Profile.find_by_user_id(current_user.id)) == nil
      @profile = Profile.new(:user_id => current_user.id)
      @profile.save
    end 

    File.open("#{RAILS_ROOT}/public/mugs/#{@profile.user_id}.jpg", "wb") do |f| 
       f.write(params[:profile][:image].read)
    end
        img = Magick::Image::read("#{RAILS_ROOT}/public/mugs/#{@profile.user_id}.jpg").first
        #img = Image.new "#{RAILS_ROOT}/public/mugs/#{@profile.user_id}.jpg"
        thumb = img.resize(96, 72)
       if thumb.write "#{RAILS_ROOT}/public/mugs/#{@profile.user_id}.jpg"
          @profile.image_location = (@profile.user_id + ".jpg")
          @profile.save
          @status_text = "Image loaded successfully"
        end  
      redirect_to :controller => "profile", :action => "index"
  end
  
  def send_invitation
    if (params[:email_invite] =~ /^\S+\@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,4}|[0-9]{1,4})(\]?)$/)
      @user = User.find(current_user)
      profile = @user.profile

      if profile.invite_count > 0
        code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join + params[:email_invite] )
        invite = Invitation.new(:code => code, :sender_user_id => current_user, :reciever_email => params[:email],
                              :count => 1)
        invite.save
        @email_search = Email.find(:first, :conditions => {:email_address => params[:email_invite]})
        if @email_search == nil
          e = Email.new(:email_address => params[:email_invite])
          e.from = "invite"
          e.save
        else
          @email_search.from = "invite"
          @email_search.save
        end
        AccountMailer.deliver_invite_sender(params[:email_invite], code, @user)
        profile.invite_count = profile.invite_count - 1
        profile.save

        render :update do |page|
          page.replace_html "invite_message_box", "Your invite has been sent to " + params[:email_invite]
          page.replace_html "invite_form", :partial => "invite_form"
          page.show "invite_message_box"
          page["email_invite"].value = ""
        end 
      else
        render :update do |page|
          page.replace_html "invite_message_box", "You don't have any invitations to send.  We'll give you more soon."
          page.replace_html "invite_form", :partial => "invite_form"
          page["email_invite"].value = ""       
        end
      end
    else
      render :update do |page|
        page.replace_html "invite_message_box", "Please enter a valid email address"
        page.show "invite_message_box"
        page["email_invite"].value = ""       
      end
    end
                            
  end
  private 
  def load_profile
    if (@profile = Profile.find_by_user_id current_user.id) == nil
      @profile = Profile.new :user_id => current_user.id
      @profile.save
    end
    @profile
  end

end
