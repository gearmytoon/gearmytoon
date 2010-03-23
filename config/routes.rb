ActionController::Routing::Routes.draw do |map|
  map.resource :home
  map.resources :areas
  map.resources :characters do |character|
    character.resources :raids
    character.resources :dungeons
    character.resource :upgrades, :member => {:from_frost_emblems => :get, :from_triumph_emblems => :get, :from_dungeons => :get}
  end
  map.root :controller => "homes", :action => "show"
end
