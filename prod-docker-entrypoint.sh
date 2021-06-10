#!/bin/sh

set -e

echo "Environment: $RAILS_ENV"

# Check if we need to install new gems
bundle check || bundle install --jobs 20 --retry 5

# Init database if does not exists
RAILS_ENV=$RAILS_ENV bundle exec rake db:prepare

# Then run any passed command
bundle exec ${@}
