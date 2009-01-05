# To change this template, choose Tools | Templates
# and open the template in the editor.

class FoodChoice
  attr_accessor :food_id, :score, :portion_id, :portion_amount, :string, :description, :servings
  def initialize
    @food_id = nil
    @score = 0
    @portion_id = nil
    @portion_amount = nil
    @string = nil
    @description = nil
    @servings = nil
  end
end
