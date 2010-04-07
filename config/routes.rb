ActionController::Routing::Routes.draw do |map|
  map.resource :home
  map.resources :areas
  map.resources :invites
  map.resources :users
  map.resources :characters do |character|
    character.resources :raids
    character.resources :dungeons
    character.resource :upgrades, :member => {:from_frost_emblems => :get, :from_triumph_emblems => :get, :from_dungeons => :get}
  end
  map.resource :account, :controller => 'users'
  map.resource :user_session
  map.login 'login', :controller => 'user_sessions', :action => 'new'
  map.signup 'signup', :controller => 'users', :action => 'new'
  map.rpx_token_sessions 'rpx_token_sessions', :controller =>"user_sessions", :action => "rpx_create"

  map.root :controller => "home"
end
