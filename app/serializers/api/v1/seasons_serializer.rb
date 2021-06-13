# frozen_string_literal: true

module Api
  module V1
    class SeasonsSerializer
      ATTRIBUTES = %i[id title plot number].freeze

      def self.serialize(seasons)
        seasons.select(ATTRIBUTES).map do |season|
          {
            id: season.id,
            title: season.title,
            plot: season.plot,
            number: season.number,
            episodes: EpisodesSerializer.serialize(season.episodes.sorted_by_number)
          }
        end
      end
    end
  end
end
