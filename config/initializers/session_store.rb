# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_wowcoach_session',
  :secret      => '3ebfc898f375c52e3f3a9b792c3846dd58d40453a93e9e10069ce2fc28d41b5ec2cff4ab01f6991787590791051a6d76281508cd4614d5de3230bb93302d7532'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
