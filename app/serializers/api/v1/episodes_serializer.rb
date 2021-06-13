# frozen_string_literal: true

module Api
  module V1
    class EpisodesSerializer
      ATTRIBUTES = %i[id title plot number].freeze

      def self.serialize(episodes)
        episodes.select(ATTRIBUTES).to_a
      end
    end
  end
end
