class BasketController < ApplicationController
  include AuthenticatedSystem
  before_filter :login_required
 
  
  def index
    flash.clear
    if request.post? && params[:meal][:the_post] == ""
      flash[:notice] = "You must enter something!"
      @meals = Meal.paginate(:all, :limit => 10,:conditions => {:user_id => current_user.id},
        :order => "created_at DESC", :page => params[:page], :per_page => 10)
      @current_user = current_user
    elsif request.post? && params[:meal][:the_post] != ""
      meal = Meal.new(:post => params[:meal][:the_post], :meal_type => params[:meal][:the_type], :user_id => current_user.id)
      unless check_comment_for_spam(current_user.login, meal.post)
        profile = current_user.profile
        begin
          if profile.twitter_username != nil && profile.twitter_password != nil && profile.twitter_active == true
            client = Twitter::Client.new(:login => profile.twitter_username,
              :password => profile.twitter_password)
            status = Twitter::Status.create(
              :text => params[:meal][:the_post],
              :client => client)
          end
        rescue
        end
        meal.save
        meal.change_created_at(params[:meal_date])
        notification = Notification.new(:friend_id => current_user.id, :friend_name => current_user.name, :object_id => meal.id, :o_type => "meal", :param_one => meal.post, :param_two => meal.meal_type, :param_four => current_user.login)
        notification.save
      end
      @meals = Meal.paginate(:all, :limit => 10, :conditions => {:user_id => current_user.id},
        :order => "created_at DESC", :page => params[:page], :per_page => 10)
      @current_user = current_user
    else
      @meals = Meal.paginate(:all, :limit => 10, :conditions => {:user_id => current_user.id},
        :order => "created_at DESC", :page => params[:page], :per_page => 10)
      @current_user = current_user
    end

  end

  def big
    @meals = Meal.paginate(:all, :include => [:user => :profile], :order => "meals.created_at DESC", :page => params[:page], :per_page => 10 )
  end
  
  def top_health
    @meals = Meal.paginate(:all, :include => [:user => :profile], :order => "meals.rating DESC", :page => params[:page], :per_page => 10 )
  end
  
  def top_taste
    @meals = Meal.paginate(:all, :include => [:user => :profile], :order => "meals.tasting DESC", :page => params[:page], :per_page => 10 )
  end
  
  def unrated
    @meals = Meal.paginate(:all, :conditions => {:rating => nil}, :include => [:user => :profile], :order => "meals.created_at DESC", :page => params[:page], :per_page => 10 )
  end
  
  def grouplist
    query = "SELECT distinct meals.id, meals.created_at, meals.rating, meals.tasting, meals.number_of_recipes, meals.number_of_comments, meals.carbs, meals.calories, meals.protein, meals.fat, meals.meal_type, users.login, meals.user_id, meals.post
        FROM (users INNER JOIN group_memberships ON users.id = group_memberships.user_id) INNER JOIN meals ON group_memberships.user_id = meals.user_id INNER JOIN groups on group_memberships.group_id = groups.id
        where users.id = #{current_user.id} ORDER BY meals.created_at DESC"
    @meals = Meal.paginate_by_sql(query, :page => params[:page], :per_page => 10)
  end

  def ratingtaste
    @meals = Meal.paginate(:all, :conditions => ["rating is not NULL"], :include => [:tastings, :ratings], :order => "created_at desc", :page => params[:page], :per_page => 10)
  end

  def user
    @user = User.find_by_login(params[:user])
    @meals = Meal.paginate(:all, :order => "created_at DESC", :conditions => {:user_id => @user.id}, :page => params[:page], :per_page => 10)
    
    friend = Friendship.find(:all, :conditions => {:user_id => current_user.id, :friend_id => @user.id})
    if friend.size > 0
      @following = true
    else
      @following = false
    end
  end

  def copy
    new_meal  = Meal.find(params[:meal_id]).copy(current_user.id)
    redirect_to :controller => "bark", :action => "edit", :id => new_meal.id
  end

  def delete_meal
    meal = Meal.find(params[:meal_id])
    meal.transaction do
      Rating.delete_all("meal_id = #{params[:meal_id]}")
      Tasting.delete_all("meal_id = #{params[:meal_id]}")
      Comment.delete_all("meal_id = #{params[:meal_id]}")
      MealFood.delete_all("meal_id = #{params[:meal_id]}")
      Notification.delete_all("friend_id = #{current_user.id} and object_id = #{params[:meal_id]} and o_type='meal'")
    end
    Meal.delete(params[:meal_id])
    render :update do |page|
      @meals = Meal.paginate(:all, :limit => 10, :conditions => {:user_id => current_user.id}, :order => "created_at DESC", :page => params[:page], :per_page => 10)
      params = nil
      page.replace_html "meal_list", :partial => "meal_list"
    end
  end
  
  def follow
    friend = Friendship.new(:user_id => current_user.id, :friend_id => params[:follow_user])
    friend.save
    @following = true
    @user = User.find(params[:follow_user])
    render :update do |page|
       page.replace_html "following_box_" + @user.id.to_s, :partial => "following"
    end
  end
  
  def stop_following
    friend = Friendship.find(:first, :conditions => {:user_id => current_user.id, :friend_id => params[:follow_user]})
    friend.destroy
    @following = false
    @user = User.find(params[:follow_user])
    render :update do |page|
       page.replace_html "following_box_" + @user.id.to_s, :partial => "following"
    end
  end

   def groups
    user = User.find(current_user.id)
    @groups = user.groups.paginate(:all, :per_page => 20, :page => params[:page])
  end

     def join
    groupmem = GroupMembership.new(:user_id => current_user.id, :group_id => params[:group_id])
    groupmem.save
    @following = true
    group = Group.find(params[:group_id])
    render :update do |page|
       page.replace_html "joining_box_" + params[:group_id], :partial => "joining", :locals => {:group => group}
    end
  end

   def leave_group
    groupmem = GroupMembership.delete_all("user_id = #{current_user.id} and group_id = #{params[:group_id]}")
    @following = false
    group = Group.find(params[:group_id])
    render :update do |page|
       page.replace_html "joining_box_" + params[:group_id], :partial => "joining", :locals => {:group => group}
    end
  end
end
