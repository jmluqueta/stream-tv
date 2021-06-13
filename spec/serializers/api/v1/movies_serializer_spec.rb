# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::MoviesSerializer do
  describe '.serialize' do
    it 'returns the correct format' do
      create_list(:movie, 3)

      sorted_movies = Movie.sorted_by_created_at
      expected_format = sorted_movies.select(:id, :plot, :title).to_a

      expect(described_class.serialize(sorted_movies)).to match_array(expected_format)
    end
  end
end
