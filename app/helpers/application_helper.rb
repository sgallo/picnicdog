# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def get_activity_list(the_user)
    @friends = Friendship.find(:all, :conditions => {:user_id => the_user})
    if @friends.size != 0
     
      #      @meals = Meal.find_by_sql("SELECT meals.id, meals.created_at, meals.rating, meals.tasting, meals.number_of_recipes, meals.number_of_comments, meals.meal_type, users.id, users.login, meals.user_id, meals.id, meals.post
      #        FROM (users INNER JOIN friendships ON users.id = friendships.user_id) INNER JOIN meals ON friendships.friend_id = meals.user_id
      #        where users.id = #{current_user.id} ORDER BY meals.created_at DESC Limit 5" )

      @notifications = Notification.find_by_sql("SELECT * FROM (users INNER JOIN friendships ON users.id = friendships.user_id) INNER JOIN notifications ON friendships.friend_id = notifications.friend_id
        where users.id = #{current_user.id} ORDER BY notifications.created_at DESC Limit 10" )
    
    end
    return @notifications
  end

  def taste_and_ratings(meal_id)
    @list = Array.new

    meal = Meal.find(meal_id)
    meal.ratings.each do |the_rating|
      review = Hash.new
      tasting = Tasting.find(:first, :conditions => {:user_id => the_rating.user_id, :meal_id => meal.id})
      if the_rating.user_id != current_user.id
        @user = User.find(the_rating.user_id)
        review[:name] = @user.name
        review[:rating] = the_rating.rating
        review[:tasting] = tasting.tasting
        @list << review
      end
    end
    
    return @list
  end
  
  #this is used for the double submit button post so the controller can see it in the foot/portion_list

end
