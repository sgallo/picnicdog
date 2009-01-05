class FoodController < ApplicationController

 
  def add_food
    if params[:id] != "" && params[:portion][:portion_id] != "" && params[:servings] != ""
      @food_choice = FoodChoice.new
      @food_choice.food_id = params[:food_id]
      @food_choice.portion_id = params[:portion][:portion_id]
      @food_choice.servings = params[:servings]
      session[:meal_list].push @food_choice
      render :update do |page|
        page.replace_html "meal_list", :partial => "meal_list", :locals => {:meal_list => session[:meal_list]}
        page.hide "message_box"
        #page.insert_html :after, 'item', :partial => "meal_item", :locals => {:food_choice => @food_choice}
      end
    else
       render :update do |page|
        page.replace_html "message_box", "*All fields are required"
        page.show "message_box"
      end
    end
  end
  
  def delete_food
    session[:meal_list].delete_if { |x| x.food_id == params[:food_id]} 
    render :update do |page|
      page.replace_html "meal_list", :partial => "meal_list", :locals => {:meal_list => session[:meal_list]}
    end
  end
  
  def lookup
      flash.clear
      if request.post? && params[:search][:query] == ""
        flash[:notice] = "You must enter something!"
      elsif request.post? || params[:page] != nil
        string = ""
        #check if query is being sent through paginate or from box
        if params[:q] == nil
          @q = params[:search][:query]
          query = "SELECT *, MATCH (description) AGAINST ('#{@q}') AS score FROM foods order by score desc"
        else
          @q = params[:q]
          query = "SELECT *, MATCH (description) AGAINST ('#{@q}') AS score FROM foods order by score desc"
        end
        @list = Food.paginate_by_sql query, :per_page => 25, :page => params[:page]
        if @list == nil || @list.size == 0
          flash[:notice] = "Nothing Found"
        end
      end
    end
    #@list = Food.find(:all, :conditions => ["MATCH (description) AGAINST ('cheese') AS score"])
    #@list = Food.find_by_sql("SELECT *, MATCH (description) AGAINST ('garlic bread') AS score FROM foods order by score desc limit 10")
    #query = "SELECT *, MATCH (description) AGAINST ('garlic bread') AS score FROM foods order by score desc"
    #@list = Food.paginate_by_sql query, :per_page => 10, :page => params[:page]

  def select_food
    food = Food.find(params[:food_id])
    weights = food.weights
    render :update do |page|
      page.replace_html "portion_list", :partial => "portion_list", :locals => {:food_id => food.id, :weights => weights}
      page.hide "nutrition_label"
    end
  end

  def label_update
    if params[:quantity] == ""
      quantity = 1
    else
      quantity = params[:quantity]
    end

    #nut = Hash.new
    food = Food.find(params[:food_id])
    weight = Weight.find(params[:select_weight][:id])
    nut_list = food.get_nutrients(weight)
    #fat_nut = NutrientData.find(:first, :conditions => {:food_id => food.id, :nutrient_id => 204})
    #nut[:fat] = (fat_nut.nutr_val * weight.gm_wgt)/100
    render :update do |page|
      page.replace_html "nutrition_label", :partial => "nutrition_label", :locals => {:nut_list => nut_list}
      page.show "nutrition_label"
    end
  end

  def submit_meal
  end

  
end
