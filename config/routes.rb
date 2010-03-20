ActionController::Routing::Routes.draw do |map|
  map.resources :areas
  map.resources :characters do |character|
    character.resources :raids
    character.resources :dungeons
    character.resource :upgrades, :member => {:from_frost_emblems => :get, :from_triumph_emblems => :get}
  end
  map.root :controller => "characters", :action => "index"
end
