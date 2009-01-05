module AccountHelper
  
    def getCurrentUser
    user = User.find(current_user)
  end
end