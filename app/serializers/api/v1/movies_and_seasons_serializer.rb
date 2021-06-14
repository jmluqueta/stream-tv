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

          content_hash.merge!(ContentData.season_data(content)) if content.type == 'Season'

          content_hash
        end
      end
    end
  end
end
