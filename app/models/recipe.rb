class Recipe < ActiveRecord::Base
  belongs_to :meal
  belongs_to :user
  has_many :recipe_steps
  has_many :ingredients
end
