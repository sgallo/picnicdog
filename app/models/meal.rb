class Meal < ActiveRecord::Base
  belongs_to :user
  has_many :ratings
  has_many :tastings
  has_many :comments
  has_many :recipes
  has_many :meal_foods

  
  def get_nutrition_label
    meal_nut_list = Hash.new
    #get each meal_foods from database and create a label
    self.meal_foods.each do |item|
      food = Food.find(item.food_id)
      weight = Weight.find(item.weight_id)
      nut_list = food.get_nutrients(weight, item.quantity)
      meal_nut_list = combine_lists(nut_list, meal_nut_list)
    end

    return meal_nut_list

  end

  #method adds to of our nutrient hash lists together
  def combine_lists(source, destination)
    if destination.empty?
      destination = source
    else
      source.each_key do |key|
        destination[key].value = destination[key].value + source[key].value
      end
    end
    return destination
  end

  def copy(user_id)
    new_meal = self.clone
    self.transaction do
      new_meal.number_of_comments = 0
      new_meal.rating, new_meal.tasting = nil
      new_meal.user_id = user_id
      new_meal.created_at = DateTime.now
      new_meal.save
       if !self.meal_foods.empty?
        self.meal_foods.each do |meal_food|
          new_meal_food = meal_food.clone
          new_meal_food.meal_id = new_meal.id
          new_meal_food.save
        end
      end
    end
    return new_meal
  end

  def change_created_at(date_string)
    t = self.created_at
    new_time = Time.zone.parse(date_string + " " + t.hour.to_s + ":" + t.min.to_s + ":" + t.sec.to_s)
    self.created_at = new_time
    self.save
  end

 end
