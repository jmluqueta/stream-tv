# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::SeasonsSerializer do
  describe '.serialize' do
    let(:sorted_seasons) { Season.sorted_by_created_at }
    let(:expected_format) do
      sorted_seasons.select(:id, :plot, :title, :number).map do |season|
        {
          id: season.id,
          title: season.title,
          plot: season.plot,
          number: season.number,
          episodes: []
        }
      end
    end

    it 'returns the correct format' do
      create_list(:season, 3)

      expect(described_class.serialize(sorted_seasons)).to match_array(expected_format)
    end
  end
end
