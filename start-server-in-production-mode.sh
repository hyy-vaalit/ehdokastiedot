#!/bin/sh

# Precompiles assets and starts server in production mode for local testing


echo ""
echo "Remember to edit environment/production.rb and temporarily set config.serve_static_assets = true"
echo ""
echo "------------------------------------------------------------------------------------------------"
export S3_ACCESS_KEY_ID=123
export S3_ACCESS_KEY_SECRET=123
export S3_BUCKET_NAME=http://hyy-koe

export RAILS_ENV=production

rake assets:precompile
foreman start
