ActionController::Routing::Routes.draw do |map|
  # Add your own custom routes here.
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Here's a sample route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  map.resource :archive, :member=>{:search=>:any}
  map.resources :events, :member=>{:approve=>:put}
  map.resources :users, :member=>{:login=>:get}, :new=>{:validate=>:get, :forgot_password=>:get, :reset=>:post, :change_password=>:get, :set_password=>:post} do |users|
    users.resources :events
  end
  map.resource :session
  map.connect '', :controller => "welcome", :action=>'index'

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
