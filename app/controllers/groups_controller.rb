class GroupsController < ApplicationController
  include AuthenticatedSystem
  before_filter :login_required
  # GET /groups
  # GET /groups.xml
  def index
   
    flash.clear
    if request.post? && params[:search][:query] == ""
      flash[:notice] = "You must enter something!"
    elsif request.post? || params[:page] != nil
      string = ""
      #check if query is being sent through paginate or from box
      if params[:q] == nil && params[:search] != nil
        
        @q = params[:search][:query]
        group_list = params[:search][:query].split
        string = ""
        group_list.each do |group|
          string << "LOWER(name) LIKE '%" + group.downcase + "%' and "
        end
        query = "select * from groups where " + string[0..string.size-5]
        @groups = Group.paginate_by_sql(query, :page => params[:page], :per_page => 15)
      else
       @groups = Group.paginate(:all, :page => params[:page], :per_page => 15)
      end
    else
       @groups = Group.paginate(:all, :page => params[:page], :per_page => 15)
    end
    respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @groups }
      end
  end

  # GET /groups/1
  # GET /groups/1.xml
  def show
    @group = Group.find(params[:id])
    query = "SELECT meals.created_at, meals.rating, meals.tasting, meals.number_of_recipes, meals.number_of_comments, meals.meal_type, users.login, meals.user_id, meals.id, meals.post FROM (users INNER JOIN group_memberships ON users.id = group_memberships.user_id and group_memberships.group_id = #{params[:id]}) INNER JOIN meals ON group_memberships.user_id = meals.user_id ORDER BY meals.created_at DESC"
    @meals = Meal.paginate_by_sql query, :page => params[:page], :per_page => 10
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/new
  # GET /groups/new.xml
  def new
    @group = Group.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/1/edit
  #def edit
  #  @group = Group.find(params[:id])
  #end

  # POST /groups
  # POST /groups.xml
  def create

    @group = Group.new(params[:group])
     respond_to do |format|
      if @group.save
        flash[:notice] = 'Group was successfully created.'
        format.html { redirect_to(@group) }
        format.xml  { render :xml => @group, :status => :created, :location => @group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.xml
  def update
    @group = Group.find(params[:id])

    respond_to do |format|
      if @group.update_attributes(params[:group])
        flash[:notice] = 'Group was successfully updated.'
        format.html { redirect_to(@group) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

   
  # DELETE /groups/1
  # DELETE /groups/1.xml
  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to(groups_url) }
      format.xml  { head :ok }
    end
  end

  
    def join
    groupmem = GroupMembership.new(:user_id => current_user.id, :group_id => params[:group_id])
    groupmem.save
    @following = true
    group = Group.find(params[:group_id])
    render :update do |page|
       page.replace_html "joining_box_" + params[:group_id], :partial => "joining", :locals => {:group => group}
    end
  end

   def leave_group
    groupmem = GroupMembership.delete_all("user_id = #{current_user.id} and group_id = #{params[:group_id]}")
    @following = false
    group = Group.find(params[:group_id])
    render :update do |page|
       page.replace_html "joining_box_" + params[:group_id], :partial => "joining", :locals => {:group => group}
    end
  end

end
