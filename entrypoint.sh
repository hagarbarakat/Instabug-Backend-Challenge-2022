#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid
bundle exec rake db:create 
bundle exec rake db:migrate
#bundle exec rake elasticsearch:build_index
bundle exec rails server -b 0.0.0.0
# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
