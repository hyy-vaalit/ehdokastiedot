# coding: utf-8

# Configurations
REDIS.set 'mailaddress', 'hostmaster-hyy@enemy.fi'

# Create a default user
AdminUser.create!(:email => 'admin@example.com', :password => 'password', :password_confirmation => 'password', :role => 'admin')
