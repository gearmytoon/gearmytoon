ActionController::Routing::Routes.draw do |map|
  map.resource :home
  map.resources :areas
  map.resources :invites
  map.resources :users
  map.resources :characters, :member => {:pvp => :get} do |character|
    character.resources :raids
    character.resources :dungeons
    character.resource :upgrades, :member => {:from_frost_emblems => :get, :from_triumph_emblems => :get,
                                              :from_dungeons => :get, :from_25_man_raids => :get,
                                              :from_10_man_raids => :get}
    character.resource :pvp_upgrades, :member => {:from_frost_emblems => :get, :from_triumph_emblems => :get, 
                                              :from_honor_points => :get, :from_wintergrasp_marks => :get}
  end
  map.resource :account, :controller => 'users'
  map.resource :user_session
  map.login 'login', :controller => 'user_sessions', :action => 'new'
  map.signup 'signup', :controller => 'users', :action => 'new'
  map.rpx_token_sessions 'rpx_token_sessions', :controller =>"user_sessions", :action => "rpx_create"

  map.namespace 'admin' do |admin|
    admin.resources :users, :characters, :items, :character_items, :active_scaffold => true
  end
  map.admin 'admin', :controller => 'admin', :action => 'index'

  map.interested 'interested', :controller => 'home', :action => 'interested'
  map.reasons 'reasons', :controller => 'home', :action => 'reasons'
  map.root :controller => "home"
end
