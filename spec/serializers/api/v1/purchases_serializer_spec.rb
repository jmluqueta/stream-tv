# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::PurchasesSerializer do
  describe '.serialize_for_user_library' do
    let(:sorted_purchases) { Purchase.sorted_by_expired_at }
    let(:expected_format) do
      movie = Movie.first
      movie_purchase_option = movie.purchase_options.first
      season = Season.first
      season_purchase_option = season.purchase_options.first

      [
        {
          id: movie.id,
          title: movie.title,
          plot: movie.plot,
          type: movie.type,
          quality: movie_purchase_option.quality
        },
        {
          id: season.id,
          title: season.title,
          plot: season.plot,
          type: season.type,
          quality: season_purchase_option.quality,
          number: season.number,
          episodes: []
        }
      ]
    end

    before do
      create(:purchase, :for_movie)
      create(:purchase, :for_season)
    end

    it 'returns the correct format' do
      expect(described_class.serialize_for_user_library(sorted_purchases)).to match_array(expected_format)
    end
  end
end
