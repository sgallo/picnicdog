# To change this template, choose Tools | Templates
# and open the template in the editor.

class FoodSet
  @meal_index = 0
  @sub_index = 0
  @food_items = nil
  @food_choice = nil
  @found = nil
  attr_accessor :queried_foods
  @limit = 0
  def initialize(meal)
    @meal = meal
    @queried_foods = Array.new
    @selected_foods = Array.new
    @sub_index = 0
  end

  def populate_single_food
   food = Food.find_by_sql("SELECT id, description, MATCH (description) AGAINST ('" + @meal + "') AS score FROM foods order by score desc")
   food.each do |item|
        @food_choice = FoodChoice.new
        @food_choice.food_id = item.id
        @food_choice.score = item.score
        @food_choice.description = item.description
        str_array = @meal.split(" ")
        record_contains = true
        str_array.each do |food_item|
          #the_food = Food.find(item.id)
          if !item.description.downcase.include? food_item
            record_contains = false
          end
        end
        @queried_foods << @food_choice if record_contains == true
      end
   end
  
  def populate(limit)
    @limit = limit
    @meal_index = 0
    @found = 0 #prime as true so it starts and gets the first food
    @food_items = @meal.split(' ')
    @food_choice = FoodChoice.new

    food_item_index = 0 #index to count where you are in the food item list
    
    #while food_item_index <= @food_items.size + 1
    while @meal_index < @food_items.size  
      if @found == 0
        get_new_food()
      else
        continue_with_current_food()
      end
      food_item_index = food_item_index + 1
    end

    
  end

  def get_new_food()
   smah = @food_items[@meal_index.to_i]
    food = Food.find_by_sql("SELECT id, description, MATCH (description) AGAINST ('" + @food_items[@meal_index.to_i] + "') AS score FROM foods order by score desc limit " + @limit.to_s)
    if (food[0].score.to_i > @food_choice.score.to_i) && (@meal_index.to_i != (@food_items.size.to_i - 1))
      @food_choice.food_id = food[0].id
      @food_choice.score = food[0].score
      @food_choice.string = @food_items[@meal_index.to_i]
      @food_choice.description = food[0].description
      @found = 1
      @sub_index = @sub_index + 1
    else #used to store the last item in the list
      @food_choice.food_id = food[0].id
      @food_choice.score = food[0].score
      @food_choice.string = @food_items[@meal_index.to_i]
      @food_choice.description = food[0].description
      #set the meal_index so it gets the last record in case it goes over
      if (@meal_index.to_i > @food_items.size - 1)
        @meal_index = food_items.size - 1
      end
      if record_contains_string(@food_items[@meal_index.to_i], @food_choice.description)
        store_food()
      end
      @meal_index = @meal_index + 1
    end
  end

  def continue_with_current_food()

    string = ""
    count = 0
    number_of_times = @sub_index + 1 #need this as array indexes start at 0
    if (@meal_index == (@food_items.size - 1)) && (@sub_index != 0)
       @queried_foods << @food_choice
    else
      while count < number_of_times
        index = @meal_index.to_i + count.to_i
        if (@meal_index + @sub_index) > (@food_items.size - 1) #gtet at you need the extra =
          index = @food_items.size - 1
        end
        string = string + @food_items[index] + " "
        count = count + 1
      end
    end 
    
    food = Food.find_by_sql("SELECT id, description, MATCH (description) AGAINST ('" + string + "') AS score FROM foods order by score desc limit " + @limit.to_s)
    #if new choice was better than the last food choice, store the choice and look for another incase the next is better
    if food[0].score > @food_choice.score && record_contains_string(string, @food_choice.description)
      @food_choice.food_id
      @food_choice.score = food[0].score
      @food_choice.string = string
      @food_choice.description = food[0].description
      @found = 1
      @sub_index = @sub_index + 1
    #if new choice is not better save the food to the list of queryied foods and start over with a new meal_list index
    else
      #always check before you save the food
      store_food()
      #A food was found so set the meal index to sub index so it
      #starts at the food that didin't have a 
      #higher match value than the combo before it
      @meal_index = @sub_index + @meal_index
      @sub_index = 0
      @found = 0
      @food_choice = FoodChoice.new
    end

  end

  def record_contains_string(string, description)
    str_array = string.split(' ')
    #food = Food.find(food_id)
    record_contains = true
    str_array.each do |item|
      if description.downcase.include? item.downcase
        record_contains = false
      end
    end
    return record_contains
  end
  
  def store_food
    string = @food_choice.string
    food = Food.find_by_sql("SELECT id, description, MATCH (description) AGAINST ('" + @food_choice.string + "') AS score FROM foods order by score desc limit " + @limit.to_s)
      food.each do |item|
        @food_choice = FoodChoice.new
        @food_choice.food_id = item.id
        @food_choice.score = item.score
        @food_choice.description = food[0].description
        str_array = string.split(" ")
        record_contains = true
        str_array.each do |food_item|

          if !item.description.downcase.include? food_item
            record_contains = false
          end
        end
        @queried_foods << @food_choice if record_contains == true
      end
  end

end
