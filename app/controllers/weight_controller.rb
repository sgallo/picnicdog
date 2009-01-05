
class WeightController < ApplicationController
 
  include AuthenticatedSystem
  def index
    @weights = UserWeight.paginate(:all, :conditions => {:user_id => current_user}, :order => "created_at desc", :page => params[:page], :per_page => 10)
    @days = 20
    @chart_weights = UserWeight.find(:all, :conditions => {:user_id => current_user}, :order => "created_at asc", :limit => @days)
    ############ For GOOGLE chart display ################
    @chart_data = ""
    @chart_weights.each do |weight|
      @chart_data << weight.weight.to_s + ","
    end
    @chart_data = @chart_data[0..@chart_data.size-2]

    ############# For GOOGLE chart ranges ############3
    @data = Array.new
    @weights.each do |weight|
      @data << weight.weight
    end
    @data = @data.sort
    @min_range = @data[0]
    @max_range = @data[@data.size-1]
    ##########################################
  end

    
  #@data = "100,40,60,60,45,47,75,70,72,100"

  
#def graph_code
#  render :text => %'{"title": {"text": "MY TITLE"}, "elements": [{"type": "bar_glass", "values": [1, 2, 3, 4, 5, 6, 7, 8, 9]}]}'
#end

#def graph_code
#    title = Title.new("MY TITLE")
#    bar = BarGlass.new
#    bar.set_values([1,2,3,4,5,6,7,8,9])
#    chart = OpenFlashChart.new
#    chart.set_title(title)
#    chart.add_element(bar)
#
#  render :text => chart.to_json
# end

  
#  def simple_js(obj)
#    q = '"'
#    json = '{ '
#    for i in obj.attributes
#      #escape single quotes; a </script> tag would also be bad
#      value = i[1].to_s.gsub(/'/, "'+#{q}'#{q}+'")
#      json << "'#{i[0]} : '#{value}'"
#    end
#    return json.sub(/, $/, ' }')
#  end
 

def add_weight
  if params[:weight] == ""
    flash[:notice] = "You must enter a weight"
    redirect_to :controller => "weight", :action => "index"
  else
    weight = UserWeight.new(:weight => params[:weight], :date => Date.civil(params[:date][:"the_date(1i)"].to_i,params[:date][:"the_date(2i)"].to_i,params[:date][:"the_date(3i)"].to_i), :user_id => current_user)
    if weight.save
      redirect_to :controller => "weight", :action => "index"
    else
      flash[:notice] = "You must enter a weight"
      redirect_to :controller => "weight", :action => "index"
    end
  end
end

def delete_weight
  weight = UserWeight.find(params[:weight_id])
  if weight.user.id == current_user.id
    weight.delete
    redirect_to :controller => "weight", :action => "index"
  else
    redirect_to :controller => "accounts", :action => "new"
  end
end

end
