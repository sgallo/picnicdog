
ActionController::Routing::Routes.draw do |map|
  map.resources :groups

  map.resources :invitations

  #map.resources :users
  #map.resource :accounts

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  map.connect 'newuser/:invite', :controller => 'users', :action => 'new'
  map.connect 'basket/index/:offset', :controller => 'basket', :action => 'index'
  map.connect 'basket/big/:offset', :controller => 'basket', :action => 'big'
  map.connect 'friends/stream', :controller => 'friends', :action => 'stream'
  map.connect 'reporting', :controller => 'reporting', :action => 'index'
  #the 2 routes below are for showing a user
  
  map.connect 'basket/user/:user', :controller => 'basket', :action => 'user'
  map.connect 'unsubscribe/email/', :controller => 'unsubscribe', :action => 'email'
  map.connect 'user/groups', :controller => 'users', :action => 'groups'

  map.connect 'basket/grouplist', :controller => 'basket', :action => 'grouplist'
  map.connect 'basket/ratingtaste', :controller => 'basket', :action => 'ratingtaste'

  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  map.no_invite 'no_invite', :controller => 'users', :action => 'no_invite'
  map.spam 'spam', :controller => 'users', :action => 'spam'
  
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "accounts", :action => "new"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

end
