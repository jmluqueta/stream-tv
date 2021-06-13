# frozen_string_literal: true

module Api
  module V1
    class MoviesSerializer
      ATTRIBUTES = %i[id title plot].freeze

      def self.serialize(movies)
        movies.select(ATTRIBUTES).to_a
      end
    end
  end
end
