ActionController::Routing::Routes.draw do |map|
  map.resources :events, :member => {:done => :post}, :collection => {:create_quickie => :post}
  map.period_events 'events/period/:period', :controller => 'events', :action => 'index'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
