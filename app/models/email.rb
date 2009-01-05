class Email < ActiveRecord::Base
  validates_uniqueness_of   :email_address, :case_sensitive => false
  validates_format_of :email_address,
                      :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i


    
end
