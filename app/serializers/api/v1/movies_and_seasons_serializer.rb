# frozen_string_literal: true

module Api
  module V1
    class MoviesAndSeasonsSerializer
      ATTRIBUTES = %i[id title plot number type].freeze

      def self.serialize(movies_seasons)
        movies_seasons.select(ATTRIBUTES).map do |content|
          content_hash = {
            id: content.id,
            title: content.title,
            plot: content.plot,
            type: content.type
          }

          content_hash.merge!(season_data(content)) if content.type == 'Season'

          content_hash
        end
      end

      def self.season_data(season)
        {
          number: season.number,
          episodes: EpisodesSerializer.serialize(season.episodes.sorted_by_number)
        }
      end
    end
  end
end
