# frozen_string_literal: true

# == Schema Information
#
# Table name: contents
#
#  id         :bigint           not null, primary key
#  number     :integer
#  plot       :text(65535)      not null
#  title      :string(255)      not null
#  type       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  parent_id  :bigint
#
# Indexes
#
#  index_contents_on_parent_id  (parent_id)
#
# Foreign Keys
#
#  fk_rails_...  (parent_id => contents.id)
#
FactoryBot.define do
  factory :season do
    sequence(:number)
    plot { Faker::Movie.quote }
    title { Faker::Movie.title }

    trait(:with_episodes) do
      after(:create) do |season|
        create_list(:episode, 5, season: season)
      end
    end
  end
end
