# frozen_string_literal: true

# == Schema Information
#
# Table name: purchase_options
#
#  id               :bigint           not null, primary key
#  price            :decimal(8, 2)    not null
#  purchasable_type :string(255)      not null
#  quality          :string(255)      not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  purchasable_id   :bigint           not null
#
# Indexes
#
#  index_purchase_options_on_purchasable  (purchasable_type,purchasable_id)
#
FactoryBot.define do
  factory :purchase_option do
    price { Faker::Number.decimal(l_digits: 1, r_digits: 2) }
    quality { PurchaseOption::ALLOWED_VIDEO_QUALITIES.sample }
    for_movie

    trait :for_movie do
      association(:purchasable, factory: :movie)
    end

    trait :for_season do
      association(:purchasable, factory: :season)
    end
  end
end
