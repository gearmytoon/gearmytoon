class Admin::UsersController < AdminController
  active_scaffold do |config|
    config.columns = [:email, :identity_url]
  end
end
