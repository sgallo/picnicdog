class Food < ActiveRecord::Base
  has_many :food_nutrients
  has_many :nutrients, :through => :food_nutrients
  has_many :weights
  #has_many :portions, :through => :weights

 
  def get_nutrients (weight, quantity)
    nut_list = Hash.new(Hash.new)
    get_nutrient_data(nut_list, weight.gm_wgt, quantity, 208) #KCAL
    get_nutrient_data(nut_list, weight.gm_wgt, quantity, 268) #KILOJOULES
    get_nutrient_data(nut_list, weight.gm_wgt, quantity, 204) #FAT fat
    get_nutrient_data(nut_list, weight.gm_wgt, quantity, 605) #FATRN trans fat
    get_nutrient_data(nut_list, weight.gm_wgt, quantity, 606) #FASAT sat fat
    get_nutrient_data(nut_list, weight.gm_wgt, quantity, 645) #FAMS mono fat
    get_nutrient_data(nut_list, weight.gm_wgt, quantity, 646) #FAPU poly fat
    get_nutrient_data(nut_list, weight.gm_wgt, quantity, 601) #CHOLE Cholesterol
    get_nutrient_data(nut_list, weight.gm_wgt, quantity, 307) #NA Sodium
    get_nutrient_data(nut_list, weight.gm_wgt, quantity, 306) #K Potasium
    get_nutrient_data(nut_list, weight.gm_wgt, quantity, 205) #CHOCDF Carbohydrates
    get_nutrient_data(nut_list, weight.gm_wgt, quantity, 291) #FIBTG Dietary Fiber
    get_nutrient_data(nut_list, weight.gm_wgt, quantity, 269) #SUGAR Sugar
    get_nutrient_data(nut_list, weight.gm_wgt, quantity, 203) #PROCNT Protein
    get_nutrient_data(nut_list, weight.gm_wgt, quantity, 301) #CA Calcium #
    get_nutrient_data(nut_list, weight.gm_wgt, quantity, 262) #CAFFN Caffine
    return nut_list
  end

  def get_nutrient_data(nut_list, gm_wgt, quantity, nutrient_id)
    nut = Nutrient.find(nutrient_id)
    nutdata = NutrientData.find(:first, :conditions => {:food_id => self.id, :nutrient_id => nutrient_id})
    if nutdata != nil
      nut_item = NutritionItem.new((nutdata.nutr_val * gm_wgt)/100, nut.units, nut.decimal, quantity)
      nut_list[nut.tagname] = nut_item
    else
      nut_item = NutritionItem.new(0, nut.units, nut.decimal, quantity)
      nut_list[nut.tagname] = nut_item
    end
  end
  
  
end
