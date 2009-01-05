require 'digest/sha1'
class User < ActiveRecord::Base
  # Virtual attribute for the unencrypted password
 
  has_many :meals
  has_many :ratings
  has_many :tastings
  has_many :comments
  has_many :comment_messages
  has_one :profile
  attr_accessor :password
  has_many :friendships
  has_many :user_weights
  has_many :friends, :through => :friendships
  has_many :group_membership
  has_many :groups, :through => :group_membership

#  has_and_belongs_to_many :friends,
#    :class_name => 'User',
#    :join_table => 'friends',
#    :foreign_key => 'user_id',
#    :association_foreign_key => 'friend_id'

  
#  has_and_belongs_to_many :friends,
#                          :join_table => 'friends',
#                          :foreign_key => 'user_id',
#                          :association_foreign_key => 'friend_id'
#                      
                          
  

  validates_presence_of     :login, :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :email, :case_sensitive => false
  before_save :encrypt_password
  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation

  def friends_meals
    self.friends.collect(&:meals).flatten
  end 
  
  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end
  

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end
  
  #password reset stuff
  def forgot_password
     @forgotten_password = true
     self.make_password_reset_code
   end

   def reset_password
     # First update the password_reset_code before setting the 
     # reset_password flag to avoid duplicate email notifications.
     update_attributes(:password_reset_code => nil)
     @reset_password = true
   end

   def recently_reset_password?
     @reset_password
   end

   def recently_forgot_password?
     @forgotten_password
   end

   def name
     if self.profile.full_name != nil && self.profile.full_name != ""
       self.profile.full_name
     else
       self.login
     end
   end
   protected

   def make_password_reset_code
     self.password_reset_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
   end

     # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
      
    def password_required?
      crypted_password.blank? || !password.blank?
    end
    
    
end
