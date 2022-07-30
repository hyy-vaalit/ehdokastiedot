web: bundle exec puma -C config/puma.rb
worker:  bundle exec rake jobs:work
# Allows signing in locally with Haka test using "hyy.voting.test.local"
sslproxy: local-ssl-proxy --source 3001 --target 3000
