class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :meal
  has_many :comment_messages, :order => "created_at asc"
end
