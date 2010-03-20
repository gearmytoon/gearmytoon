ActionController::Routing::Routes.draw do |map|
  map.resources :areas
  map.resources :characters do |character|
    character.resources :raids
    character.resources :dungeons
  end
  map.root :controller => "characters", :action => "index"
end
