class UnsubscribeController < ApplicationController

  def email
    if params[:email] != nil
      if @email = Email.find(:first, :conditions => {:email_address => params[:email]})
        @email.subscription = 1
        @email.save
      else
        @email = nil
      end
    end
  end

end
