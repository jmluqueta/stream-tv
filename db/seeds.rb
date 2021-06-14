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

# Create purchase_options
create(:purchase_option, purchasable_id: Movie.first.id, purchasable_type: 'Movie', quality: 'HD', price: 3.99)
create(:purchase_option, purchasable_id: Movie.first.id, purchasable_type: 'Movie', quality: 'SD', price: 2.99)
create(:purchase_option, purchasable_id: Season.first.id, purchasable_type: 'Season', quality: 'HD', price: 9.99)
create(:purchase_option, purchasable_id: Season.first.id, purchasable_type: 'Season', quality: 'SD', price: 7.99)

# Create users
create_list(:user, 2)

# Create purchases
create(:purchase, purchase_option_id: PurchaseOption.first.id, user_id: User.last.id)
create(:purchase, purchase_option_id: PurchaseOption.last.id, user_id: User.last.id)
