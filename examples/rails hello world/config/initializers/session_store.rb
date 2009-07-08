# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_renshi_test_session',
  :secret      => '49078e58eadd6ee57c75a3e5f79fb746ad841cc0cc2deb5a13f793a1de638a91ac95af885dfa86f190d5ed30489b7d072d47c5b04d31d36a8705736a901bbe08'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
