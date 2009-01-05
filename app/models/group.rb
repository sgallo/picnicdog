class Group < ActiveRecord::Base
  has_many :group_memberships
  has_many :users, :through => :group_membership

  def members_count
    GroupMembership.count(:all, :conditions => {:group_id => self.id})
  end

end
