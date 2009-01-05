class Friendship < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :friend, :class_name => 'User', :foreign_key => 'friend_id'
  has_many :meals, :through => :users
end
