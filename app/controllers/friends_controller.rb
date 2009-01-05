class FriendsController < ApplicationController
before_filter :login_required
  #todo need to check if person is freind before they can see any of these friends list

  def index
    @friends = Friendship.paginate(:all, :conditions => {:user_id => current_user.id}, :page => params[:page], :per_page => 10)
  end
  
  def feed
    user = User.find(params[:id])
    if user.profile.private == false
      @meals = Meal.find_by_sql("SELECT meals.id, meals.created_at, meals.rating, meals.tasting, meals.number_of_recipes, meals.number_of_comments, meals.meal_type, meals.carbs, meals.calories, meals.protein, meals.fat, users.id, users.login, meals.user_id, meals.id, meals.post
        FROM (users INNER JOIN friendships ON users.id = friendships.user_id) INNER JOIN meals ON friendships.friend_id = meals.user_id
        where users.id = #{params[:id]} ORDER BY meals.created_at DESC limit 20" )
      @current_user = current_user
    end
  end
  
  def stream
#    @meals = Meal.find_by_sql("SELECT meals.id, meals.created_at, meals.rating, meals.tasting, meals.number_of_recipes, meals.number_of_comments, meals.meal_type, users.id, users.login, meals.user_id, meals.id, meals.post
#        FROM (users INNER JOIN friendships ON users.id = friendships.user_id) INNER JOIN meals ON friendships.friend_id = meals.user_id
#        where users.id = #{current_user.id} ORDER BY meals.created_at DESC Limit 30" )
    query = "SELECT meals.id, meals.created_at, meals.rating, meals.tasting, meals.number_of_recipes, meals.number_of_comments, meals.meal_type, meals.carbs, meals.calories, meals.protein, meals.fat, users.login, meals.user_id, meals.post
        FROM (users INNER JOIN friendships ON users.id = friendships.user_id) INNER JOIN meals ON friendships.friend_id = meals.user_id
        where users.id = #{current_user.id} ORDER BY meals.created_at DESC"
    @meals = Meal.paginate_by_sql(query, :page => params[:page], :per_page => 10)
    @profile = current_user.profile
  end

  def followerstream
#    @meals = Meal.find_by_sql("SELECT meals.id, meals.created_at, meals.rating, meals.tasting, meals.number_of_recipes, meals.number_of_comments, meals.meal_type, users.id, users.login, meals.user_id, meals.id, meals.post
#        FROM (users INNER JOIN friendships ON users.id = friendships.user_id) INNER JOIN meals ON friendships.friend_id = meals.user_id
#        where users.id = #{current_user.id} ORDER BY meals.created_at DESC Limit 30" )
    query = "SELECT meals.id, meals.created_at, meals.rating, meals.tasting, meals.number_of_recipes, meals.number_of_comments, meals.meal_type, meals.carbs, meals.calories, meals.protein, meals.fat, users.login, meals.user_id, meals.post
        FROM (users INNER JOIN friendships ON users.id = friendships.friend_id) INNER JOIN meals ON friendships.user_id = meals.user_id
        where users.id = #{current_user.id} ORDER BY meals.created_at DESC"
    @meals = Meal.paginate_by_sql(query, :page => params[:page], :per_page => 10)
    @profile = current_user.profile
  end
  
  def followers
    @followers = Friendship.paginate(:all, :conditions => {:friend_id => current_user.id}, :per_page => 10, :page => params[:page])
  end
end
