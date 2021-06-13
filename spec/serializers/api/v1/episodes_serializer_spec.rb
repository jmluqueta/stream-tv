# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::EpisodesSerializer do
  describe '.serialize' do
    it 'returns the correct format' do
      create_list(:episode, 3)

      sorted_episodes = Episode.sorted_by_number
      expected_format = sorted_episodes.select(:id, :plot, :title, :number).to_a

      expect(described_class.serialize(sorted_episodes)).to match_array(expected_format)
    end
  end
end
