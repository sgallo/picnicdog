# To change this template, choose Tools | Templates
# and open the template in the editor.

class NutritionItem
  
  attr_accessor :value #value of nutrient
  attr_accessor :units #units, gm, kg
  attr_accessor :decimal #number of decimals
  
  def initialize(value, units, decimal, quantity)
    self.value = value * quantity.to_i
    self.units = units
    self.decimal = decimal
  end
end
