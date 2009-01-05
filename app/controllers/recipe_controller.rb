class RecipeController < ApplicationController
  before_filter :login_required
  
  
  def new

    @meal = Meal.find(params[:id])
    @user = @meal.user
    #@recipes = @meal.recipes
    @recipes = Recipe.find(:all, :conditions => {:meal_id => params[:id]})
    session[:ingredient_list] = Array.new
    session[:ingredient_list].push nil
    session[:recipe_steps] = Array.new
    session[:recipe_steps].push nil
    friend = Friendship.find(:all, :conditions => {:user_id => current_user.id, :friend_id => @user.id})
    if friend.size > 0
      @following = true
    else
      @following = false
    end
    
  end
  
  def add_ingredient
    if params[:the_ingredient] != ""
      session[:ingredient_list].push params[:the_ingredient]
      render :update do |page|
        page.replace_html "ingredient_box", :partial => "ingredient_list", :locals => {:ingredient_list => session[:ingredient_list]}
        page["the_ingredient"].value = ""
      end
    else
       render :update do |page|
        page.replace_html "message_box", "*Ingredient can't be empty.  Need to know what to cook!"
      end
    end
    
  end
  
  def add_recipe_step
    if params[:the_step] != ""
      session[:recipe_steps].push params[:the_step]
      render :update do |page|
        page.replace_html "steps_box", :partial => "recipe_steps", :locals => {:recipe_steps => session[:recipe_steps]}
        page["the_step"].value = ""
      end
    else
      render :update do |page|
        page.replace_html "message_box", "*Step can't be empty.  How will we cook it?"
      end
    end
  end
  
  def submit_recipe
    #if no ingredients or steps
    if session[:ingredient_list][1] == nil || session[:recipe_steps][1] == nil || params[:title] == nil || params[:the_description] == nil
      render :update do |page|
        page.replace_html "message_box", "*You must enter a title, description, ingredients and steps.*"
      end
    #else save the recipe
    else
      Recipe.transaction do
        recipe = Recipe.new(:title => params[:title], :meal_id => params[:meal_id], :user_id => current_user.id, :description => params[:the_description])
        recipe.save

        meal = Meal.find(params[:meal_id])
        meal.number_of_recipes = meal.number_of_recipes + 1
        meal.save

        #set count to 1 as 0 index is nil
        count = 1
        session[:ingredient_list].each do |ingredient|
          if ingredient != nil
            new_ingredient = Ingredient.new(:recipe_id => recipe.id, :sort_order => count, :ingredient => ingredient)
            new_ingredient.save
            count = count + 1
          end
        end
        count = 1
        session[:recipe_steps].each do |step|
          if step != nil
            new_step = RecipeStep.new(:recipe_id => recipe.id, :sort_order => count, :step => step)
            new_step.save
            count = count + 1
          end
        end
      end
      session[:ingredient_list] = Array.new
      session[:ingredient_list].push nil
      session[:recipe_steps] = Array.new
      session[:recipe_steps].push nil
      message = "*Recipe Added*"
      @recipes = Recipe.find(:all, :conditions => {:meal_id => params[:meal_id]})
      render :update do |page|
        page.replace_html "steps_box", :partial => "recipe_steps", :locals => {:recipe_steps => session[:recipe_steps]}
        page.replace_html "ingredient_box", :partial => "ingredient_list", :locals => {:ingredient_list => session[:ingredient_list]}
        page.replace_html "the_recipe_list", :partial => "the_recipe_list"
        page["the_step"].value = ""
        page["title"].value = ""
        page["the_description"].value = ""
        page["the_ingredient"].value = ""
        page.hide "recipe_builder"
        page.replace_html "message_box", message
      end     
    end 
  end
  
  def delete_ingredient
    #session[:ingredient_list].delete_if {|key, value| key = params[:key] }
    session[:ingredient_list].delete_at(params[:index].to_i)
    render :update do |page|
      page.replace_html "ingredient_box", :partial => "ingredient_list", :locals => {:ingredient_list => session[:ingredient_list]}
    end
  end
  
  def delete_step
    session[:recipe_steps].delete_at(params[:index].to_i)
    render :update do |page|
      page.replace_html "steps_box", :partial => "recipe_steps", :locals => {:recipe_steps => session[:recipe_steps]}
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
