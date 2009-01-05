class Friend < ActiveRecord::Base
  belongs_to :user
  has_many :meals_as_friends, :foreign_key => 'friend_id', :class_name => 'Edge'

end
