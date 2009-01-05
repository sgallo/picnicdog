class Weight < ActiveRecord::Base
  belongs_to :food
  belongs_to :portion
end
