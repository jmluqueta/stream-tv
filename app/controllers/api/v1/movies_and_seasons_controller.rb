# frozen_string_literal: true

module Api
  module V1
    class MoviesAndSeasonsController < ApplicationController
      include ExceptionHandler
      include Response
      include UserAuthenticator

      def index
        @movies_and_seasons = Content.of_type_movie_and_season.sorted_by_created_at.page(params[:page])

        json_response({ movies_and_seasons: cached_movies_and_seasons })
      end

      private

      def cached_movies_and_seasons
        Rails.cache.fetch(@movies_and_seasons.cache_key, version: @movies_and_seasons.cache_version) do
          MoviesAndSeasonsSerializer.serialize(@movies_and_seasons)
        end
      end
    end
  end
end
