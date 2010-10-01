ActionController::Routing::Routes.draw do |map|
  map.resource :payment, :member => {:receipt => :get, :notify_payment => :post}
  map.resource :home, :controller => "home"
  map.resources :areas
  map.resources :creatures
  map.resources :specs, :collection => {:create_or_update => :post} do |spec|
    spec.resources :slots
  end
  map.spec "/specs/:scope/:id", :controller => "specs", :action => "show"
  map.resources :items, :member => {:tooltip => :get, :update_used_by => :post} do |item|
    item.resource :comments
  end
  map.resources :character_refreshes
  map.resources :users
  map.resource :payment_receipts
  map.resources :characters, :member => {:pvp => :get, :not_found => :get, :status => :get} do |character|
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
  map.contact 'contact', :controller => 'home', :action => 'contact'
  map.namespace 'admin' do |admin|
    admin.resources :users, :characters, :items, :character_items, :active_scaffold => true
  end
  map.admin 'admin', :controller => 'admin', :action => 'index'
  map.root :controller => "specs", :action => "index"
end
