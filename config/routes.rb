ActionController::Routing::Routes.draw do |map|
  map.resource :payment, :member => {:receipt => :get, :pay => :get}
  map.resource :home, :controller => "home", :member => {:contact => :get}
  map.resources :areas
  map.resources :character_refreshes
  map.resources :users
  map.resource :payment_receipts
  map.resources :characters, :member => {:pvp => :get, :not_found => :get} do |character|
    character.resource :upgrades, :member => {:frost => :get, :triumph => :get, :dungeon => :get, :raid_25 => :get, :raid_10 => :get} do |upgrade|
      upgrade.resources :area, :controller => "area_upgrades"
    end
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
  map.math '', :controller => 'home', :action => 'show', :anchor => 'math'
  map.testimonials '', :controller => 'home', :action => 'show', :anchor => 'testimonials'
  map.root :controller => "home", :action => "show"
end
