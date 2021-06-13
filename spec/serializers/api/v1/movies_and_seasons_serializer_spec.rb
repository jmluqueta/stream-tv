# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::MoviesAndSeasonsSerializer do
  describe '.serialize' do
    let!(:movie) { create(:movie) }
    let!(:season) { create(:season) }
    let(:sorted_movies_and_seasons) { Content.where(type: %w[Movie Season]).sorted_by_created_at }
    let(:expected_format) do
      [
        {
          id: season.id,
          title: season.title,
          plot: season.plot,
          type: season.type,
          number: season.number,
          episodes: []
        },
        {
          id: movie.id,
          title: movie.title,
          plot: movie.plot,
          type: movie.type
        }
      ]
    end

    it 'returns the correct format' do
      expect(described_class.serialize(sorted_movies_and_seasons)).to match_array(expected_format)
    end
  end
end
