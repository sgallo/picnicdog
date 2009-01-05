class ReportingController < ApplicationController
  def index

    if request.post?
      start_date = Time.zone.parse(params[:start_date])
      end_date = Time.zone.parse(params[:end_date] + " 23:59:59")
      @meal_list = Meal.find(:all, :conditions => {:created_at => start_date..end_date, :user_id => current_user.id})
      @report_list = Array.new
      @meal_list.each do |meal|
        meal_hash = Hash.new
        meal_hash[:meal] = meal
        meal_hash[:meal_nuts] = meal.get_nutrition_label
        @report_list << meal_hash
      end
      debugger
    end
  end

end
