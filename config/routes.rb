ActionController::Routing::Routes.draw do |map|
  map.resources :characters
  map.root :controller => "characters", :action => "index"
end
