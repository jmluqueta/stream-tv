# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'factory_bot_rails'
require 'faker'

include FactoryBot::Syntax::Methods

# Create movies
create_list(:movie, 30)

# Create seasons
create_list(:season, 20, :with_episodes)

# Create users
create_list(:user, 1)
