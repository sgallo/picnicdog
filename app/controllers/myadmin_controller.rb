class MyadminController < ApplicationController
  USER_NAME, PASSWORD = "pd1234", "contour1234"
  before_filter :authenticate

  def index

    
  end


  def meal_compute

    meals = Meal.find(:all)
    meals.each do |meal|
        meal_nut_list = meal.get_nutrition_label
        if !meal_nut_list.empty?
          meal.fat = meal_nut_list["FAT"].value
          meal.calories = meal_nut_list["ENERC_KCAL"].value
          meal.protein = meal_nut_list["PROCNT"].value
          meal.carbs = meal_nut_list["CHOCDF"].value
          meal.save
        end
    end

  end

  def email
     @emails = Email.paginate(:all, :page => params[:page], :per_page => 500 )
  end

  def users
    @users = User.paginate(:all, :include => [:profile], :page => params[:page], :per_page => 500 )
  end

  def mass_mail
    @users = User.find(:all, :include => [:profile])
    @users.each do |user|
      if user.profile.send_system_email == 0
        AccountMailer.deliver_mass_email(user)
      end
    end
    flash[:notice] = "Emails Sent"
    redirect_to :action => "index"
  end

  private
  def authenticate
    authenticate_or_request_with_http_basic do |user_name, password|
      user = User.find(current_user)
      user_name == USER_NAME && password == PASSWORD && (user.login == 'sgallo')
    end
  end

end
