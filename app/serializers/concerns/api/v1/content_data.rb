# frozen_string_literal: true

module Api
  module V1
    module ContentData
      def self.season_data(season)
        {
          number: season.number,
          episodes: EpisodesSerializer.serialize(season.episodes.sorted_by_number)
        }
      end
    end
  end
end
