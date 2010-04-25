ActionController::Routing::Routes.draw do |map|
  map.resource :payment, :member => {:receipt => :get}
  map.resource :home
  map.resources :areas
  map.resources :invites
  map.resources :users
  map.resources :characters, :member => {:pvp => :get} do |character|
    character.resource :upgrades, :member => {:frost => :get, :triumph => :get, :dungeon => :get, :raid_25 => :get, :raid_10 => :get}
    character.resource :pvp_upgrades, :member => {:frost => :get, :triumph => :get, :honor => :get, :wintergrasp => :get, :arena => :get}
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
  map.contact 'contact', :controller => 'home', :action => 'contact'
  map.math '', :controller => 'home', :action => 'index', :anchor => 'math'
  map.testimonials '', :controller => 'home', :action => 'index', :anchor => 'testimonials'
  map.root :controller => "home"
end
