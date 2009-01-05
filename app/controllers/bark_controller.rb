class BarkController < ApplicationController
  before_filter :login_required
  def show
    @meal = Meal.find(params[:id], :include => [:user])
    @comments = @meal.comments
    @rating = @meal.ratings.find_by_user_id(current_user.id)
    @tasting = @meal.tastings.find_by_user_id(current_user.id)
    @meal_foods = @meal.meal_foods
  end
  
	def edit
    meal = Meal.find(params[:id])
    redirect_to :controller => "accounts", :action => "new" unless meal.user_id == current_user.id
    if request.post?
			Meal.update(params[:id], :post => params[:meal][:the_post], :meal_type => params[:meal][:the_type])
      #meal = Meal.find(params[:id])
      meal.change_created_at(params[:meal_date])
			redirect_to :controller => "bark", :action => "show", :id => params[:id]
    else
    	@meal = Meal.find(params[:id], :include => [:user])
	    @comments = @meal.comments
	    @rating = @meal.ratings.find_by_user_id(current_user.id)
	    @tasting = @meal.tastings.find_by_user_id(current_user.id)
	    @meal_foods = @meal.meal_foods
    end
  end
  
   def add_comment
    comment = Comment.new(:the_comment => params[:comment][:the_comment], :meal_id => params[:meal_id], 
                          :user_id => current_user.id)
    unless check_comment_for_spam(current_user.login, comment.the_comment)
      if comment.save
        note = Notification.new(:friend_id => current_user.id, :friend_name => current_user.name,
                                :user_id => comment.meal.user.id, :user_name => comment.meal.user.name, :o_type => "comment", :object_id => comment.meal.id,
        :param_one => comment.meal.post, :param_two => comment.the_comment, :param_three => comment.meal.meal_type, :param_four => current_user.login, :param_five => comment.meal.user.login)
        note.save
        comment_user_name = current_user.name
        meal = Meal.find(params[:meal_id])
        meal_owner = meal.user
        if (meal_owner.invalid_email != 1) && (meal_owner.profile.send_comments != 1) && (meal_owner.id != current_user.id)
          AccountMailer.deliver_comment_posted(meal_owner, comment_user_name, meal.id)
        end
        
        meal.number_of_comments = meal.number_of_comments + 1
        meal.save
      end 
      
      render :update do |page|
        @comments = Comment.find(:all, :conditions => {:meal_id => params[:meal_id]})
        page.replace_html "comment_list", :partial => "comment_list"
        page["comment_the_comment"].value = ""
      end
    else
      redirect_to :controller => "users", :action => 'spam'
    end
  end

  def show_meal_nutrition_label
    meal = Meal.find(params[:meal_id])
    meal_nut_list = meal.get_nutrition_label
    render :update do |page|
      page.replace_html "meal_nutrition_label", :partial => "food/nutrition_label", :locals => {:nut_list => meal_nut_list}
      page.show "meal_nutrition_label"
    end
  end

  def delete_meal_food
    MealFood.delete(params[:meal_food_id])
    meal = Meal.find(params[:meal_id])
    @meal_foods = meal.meal_foods
    meal_nut_list = meal.get_nutrition_label
    render :update do |page|
      page.replace_html "meal_nutrition_list", :partial => "meal_nutrition_list", :locals => {:meal_id => params[:meal_id]}
      page.replace_html "meal_nutrition_label", :partial => "food/nutrition_label", :locals => {:nut_list => meal_nut_list}
    end
  end

 
  def food
    @meal = Meal.find(params[:id], :include => [:user])
    @comments = @meal.comments
    @rating = @meal.ratings.find_by_user_id(current_user.id)
    @tasting = @meal.tastings.find_by_user_id(current_user.id)
  end
  
#  def food_page
#    @q = params[:q]
#    #query = "SELECT *, MATCH (description) AGAINST ('#{@q}') AS score FROM foods order by score desc"
#    query = "SELECT distinct foods.id, foods.description, MATCH (description) AGAINST ('#{@q}') AS score FROM foods LEFT JOIN weights on foods.id = weights.food_id where weights.id is not null HAVING score > 0 order by score desc"
#    @list = Food.paginate_by_sql query, :per_page => 25, :page => params[:page]
#    render :update do |page|
#      page.replace_html "food_list", :partial => "food_list"
#    end
#
#  end
  
  def food_search
    @meal_id = params[:meal_id]
    if params[:search] != nil # means it's from pagination
      flash.clear
      if (request.post? || request.xhr?) && params[:search][:query] == ""
        flash[:notice] = "You must enter something!"
      elsif (request.post? || request.xhr?) || params[:page] != nil
        #check if query is being sent through paginate or from box
        if params[:q] == nil
          @q = params[:search][:query]
          #query = "SELECT *, MATCH (description) AGAINST ('#{@q}') AS score FROM foods order by score desc"
          query = "SELECT distinct foods.id, foods.description, MATCH (description) AGAINST ('#{@q}') AS score FROM foods LEFT JOIN weights on foods.id = weights.food_id where weights.id is not null HAVING score > 0 order by score desc"
        else
          @q = params[:q]
          #query = "SELECT *, MATCH (description) AGAINST ('#{@q}') AS score FROM foods order by score desc"
          query = "SELECT distinct foods.id, foods.description, MATCH (description) AGAINST ('#{@q}') AS score FROM foods LEFT JOIN weights on foods.id = weights.food_id where weights.id is not null HAVING score > 0 order by score desc"
        end
        @food_list = Food.paginate_by_sql query, :per_page => 25, :page => params[:page]
        if @food_list == nil || @food_list.size == 0
          flash[:notice] = "Nothing Found"
        end
      end
    else
      @q = params[:q]
      #query = "SELECT *, MATCH (description) AGAINST ('#{@q}') AS score FROM foods order by score desc"
      query = "SELECT distinct foods.id, foods.description, MATCH (description) AGAINST ('#{@q}') AS score FROM foods LEFT JOIN weights on foods.id = weights.food_id where weights.id is not null HAVING score > 0 order by score desc"
      @food_list = Food.paginate_by_sql query, :per_page => 25, :page => params[:page]
    end
    
    render :update do |page|
      page.replace_html "food_list", :partial => "food_list", :locals => {:meal_id => @meal_id}
      page.show "food_list"
    end
  end
  
  
  def select_food
    food = Food.find(params[:food_id])
    weights = food.weights
    render :update do |page|
      page.replace_html "portion_list", :partial => "food/portion_list", :locals => {:meal_id => params[:meal_id], :food_id => food.id, :food_description => food.description, :weights => weights}
      page.show "portion_list"
      page.hide "search_list"
      page.hide "nutrition_label"
    end
  end
  
  def label_update
    if params[:quantity] == ""
      quantity = 1
    else
      quantity = params[:quantity]
    end
    food = Food.find(params[:food_id])
    weight = Weight.find(params[:select_weight][:id])
    #note that this case statement is reversed due to having disable the submit buttons
    case params[:commit]
      when "Add food to meal"
        nut_list = food.get_nutrients(weight, quantity)
        render :update do |page|
          page.replace_html "nutrition_label", :partial => "food/nutrition_label", :locals => {:nut_list => nut_list}
          page.show "nutrition_label"
        end
      when "Show Label"
        meal_food = MealFood.new :food_id => food.id, :quantity => quantity, :weight_id => weight.id, :meal_id => params[:meal_id]
        meal_food.transaction do
          meal_food.save #save the meal food
          meal = Meal.find(params[:meal_id])
          @meal = Meal.find(params[:meal_id])
          @meal_foods = meal.meal_foods
          meal_nut_list = meal.get_nutrition_label
          #below is where we save the unnormalized data for the nutrients
          @meal.fat = meal_nut_list["FAT"].value
          @meal.calories = meal_nut_list["ENERC_KCAL"].value
          @meal.protein = meal_nut_list["PROCNT"].value
          @meal.carbs = meal_nut_list["CHOCDF"].value
          @meal.save
          render :update do |page|
            page.replace_html "meal_nutrition_list", :partial => "meal_nutrition_list", :locals => {:meal_id => params[:meal_id]}
            page.replace_html "meal_nutrition_label", :partial => "food/nutrition_label", :locals => {:nut_list => meal_nut_list}
          end
        end
     end
  end
  
  def return_to_list
    render :update do |page|
      page.hide "portion_list"
      page.hide "nutrition_label"
      page.show "search_list"
    end
  end
  
  def add_rating
    
    @rating = Rating.new(:rating => params[:post][:rating_list], :meal_id => params[:meal_id], 
                         :user_id => current_user.id)
    
    @tasting = Tasting.new(:tasting => params[:post][:tasting_list], :meal_id => params[:meal_id], 
                           :user_id => current_user.id)
    
    if @rating.save && @tasting.save
      profile = @rating.user.profile
      rating_total = (profile.health_avg * profile.comments_with_ratings_total) + @rating.rating
      profile.health_avg = rating_total.to_f / (profile.comments_with_ratings_total + 1).to_f
      
      tasting_total = (profile.taste_avg * profile.comments_with_ratings_total) + @tasting.tasting
      profile.taste_avg = tasting_total.to_f / (profile.comments_with_ratings_total + 1).to_f
      
      
      profile.comments_with_ratings_total = profile.comments_with_ratings_total + 1
      profile.save
      
      set_avg_rating
      set_avg_tasting
      @meal = Meal.find(params[:meal_id])
      render :update do |page|
        page.replace_html "rating_list", :partial => "rating_list"
      end
    else
      render :update do |page|
        page.replace_html "rating_error", "Error Saving Rating"
        page.show "rating_error"
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
  
  def show_reply_box
    render :update do |page|
      page.show "reply_box_" + params[:comment_id]
    end
  end
  
  def add_reply
    if params[:reply][:the_reply] == ""
      render :update do |page|
      end
    else
      unless check_comment_for_spam(current_user.login, params[:reply][:the_reply])
        reply = CommentMessage.new(:user_id => current_user.id, :comment_id => params[:comment_id], :message => params[:reply][:the_reply])
        reply.save
        @meal = Meal.find(params[:meal_id])
        @comments = @meal.comments
        comment_user_name = current_user.name
        meal_owner = @meal.user
        #send email to owner of post
        if (meal_owner.invalid_email != 1) && (meal_owner.profile.send_comments != 1) && (meal_owner.id != current_user.id)
          AccountMailer.deliver_comment_posted(meal_owner, comment_user_name, @meal.id)
        end
        #Send emails to all who particiapted with the commnet
        comment = reply.comment
        messages = CommentMessage.find_by_sql("select distinct user_id from comment_messages where comment_id="+reply.comment.id.to_s)
        messages.each do |message|
          user = User.find(message.user_id)
          if user.id != meal_owner.id && user.profile.send_comments != 1
            AccountMailer.deliver_comment_replied_to(User.find(user.id), comment_user_name, @meal.id)
          end
        end
        render :update do |page|
          page.replace_html "comment_list", :partial => "comment_list"
        end
      end
    end
  end
  
  private
  
  def set_avg_rating
    meal = Meal.find(params[:meal_id])
    total = 0
    meal.ratings.each do |rating|
      total = total + rating.rating
    end
    
    if meal.ratings.count != 0
      meal.rating = total.to_f / meal.ratings.count
    else
      meal.rating = total.to_f
    end
    
    meal.save
  end
  
  def set_avg_tasting
    meal = Meal.find(params[:meal_id])
    total = 0
    meal.tastings.each do |tasting|
      total = total + tasting.tasting
    end
    
    if meal.tastings.count != 0
      meal.tasting = total.to_f / meal.tastings.count
    else
      meal.tasting = total.to_f
    end
    meal.save
  end
  
end
