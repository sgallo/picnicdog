class SearchController < ApplicationController
  include AuthenticatedSystem
  require 'blackbook'
  before_filter :login_required
  
  if RAILS_ENV == "production"
    ssl_required :contact, :contact_search
  end

  def user
    flash.clear
    if request.post? && params[:search][:query] == ""
      flash[:notice] = "You must enter something!"
    elsif request.post? || params[:page] != nil
      string = ""
      #check if query is being sent through paginate or from box
      if params[:q] == nil
        @q = params[:search][:query]
        string = ""
        string << "LOWER(login) LIKE '%" + @q.downcase + "%' "
        query = "select * from users where " + string
      else
        @q = params[:q]
        string = ""
        string << "LOWER(login) LIKE '%" + @q.downcase + "%' "
        query = "select * from users where " + string
      end
      @user_search_result = User.paginate_by_sql query, :per_page => 20, :page => params[:page]
      if @user_search_result == nil || @user_search_result.size == 0
        flash[:notice] = "Nothing Found"
      end
    end
  end

  def recipe
    flash.clear
    if request.post? && params[:search][:query] == ""
      flash[:notice] = "You must enter something!"
    elsif request.post? || params[:page] != nil
      string = ""
      #check if query is being sent through paginate or from box
      if params[:q] == nil
        @q = params[:search][:query]
        food_list = params[:search][:query].split
        string = ""
        food_list.each do |food|
          string << "LOWER(title) LIKE '%" + food.downcase + "%' and "
        end
        query = "select * from recipes where " + string[0..string.size-5]
      else
        @q = params[:q]
        food_list = params[:q].split
        string = ""
        food_list.each do |food|
          string << "LOWER(title) LIKE '%" + food.downcase + "%' and "
        end
        query = "select * from recipes where " + string[0..string.size-5]
      end
      @recipe_search_result = Recipe.paginate_by_sql query, :page => params[:page], :per_page => 1
      if @recipe_search_result == nil || @recipe_search_result.size == 0
        flash[:notice] = "Nothing Found"
      end
    end
  end
  
  def contact
    
  end
  
  def contact_search
    @offset = 0
    if params[:mail][:the_type] == "gmail.com"
      begin
        gmail = Blackbook.get :username => params[:search][:user_name]+"@gmail.com", :password => params[:search][:password]
      rescue
        
      end
    end
    if gmail != nil
      @contacts = []
      # collect unique contacts by email address into an array
      (gmail).each do |contact|
        @contacts << contact unless
          @contacts.detect{|c| contact[:email].downcase == c[:email].downcase }
      end

      if @contacts != nil && @contacts != 0
        #this query returns everyone who has an account in PD that matches an email.
        #we also join friendships, so if friendship is nil, you are not currently a friend
        #we check for this nil in the view
        @query = "select users.id as id, users.login, profiles.about, profiles.image_location, profiles.full_name, profiles.location, friendships.friend_id from ((users left join profiles on users.id = profiles.user_id) left join friendships on users.id = friendships.friend_id) where users.email ='" + @contacts[0][:email] +"'"
                 #select users.id, users.login, profiles.about, profiles.image_location, profiles.full_name, profiles.location, friendships.id from ((users left join profiles on users.id = profiles.user_id) left join friendships on users.id = friendships.friend_id) where users.email = 'joyhgallo@gmail.com' or users.email = 'webmaster@picnicdog.com';
        index = 1
        while index < @contacts.size
          @query << " or users.email ='" + @contacts[index][:email] +"'"
          index = index + 1
        end

        @query << ";"
       
        @contact_friends = User.find_by_sql(@query)

        render :update do |page|
          page.replace_html "contact_search_result", :partial => "contact_search_result"
          page.replace_html "message_box", ""
          page.show "contact_search_result"
          page.hide "message_box"
        end
      else
        render :update do |page|
          @offset = 0
          page.replace_html "contact_search_result", :partial => "contact_search_result"
          page.replace_html "message_box", "No contacts found."
          page.show "contact_search_result"
          page.show "message_box"
        end
      end
    else
      render :update do |page|
        page.replace_html "contact_search_result", :partial => "contact_search_result"
        page.replace_html "message_box", "Could not connect to GMail.  Check Credentials."
        page.show "message_box"
      end
    end
  end

  def follow
    friend = Friendship.new(:user_id => current_user.id, :friend_id => params[:follow_user])
    friend.save
    @following = true
    @user = User.find(params[:follow_user])
    render :update do |page|
       page.replace_html "following_box_" + params[:follow_user], :partial => "following", :locals => {:user => @user}
    end
  end

   def stop_following
    friend = Friendship.find(:first, :conditions => {:user_id => current_user.id, :friend_id => params[:follow_user]})
    friend.destroy
    @following = false
    @user = User.find(params[:follow_user])
    render :update do |page|
       page.replace_html "following_box_" + params[:follow_user], :partial => "following", :locals => {:user => @user}
    end
  end
end
