# frozen_string_literal: true

module Api
  module V1
    class MoviesController < ApplicationController
      include ExceptionHandler
      include Response
      include UserAuthenticator

      def index
        @movies = Movie.sorted_by_created_at.page(params[:page])

        json_response({ movies: cached_movies })
      end

      private

      def cached_movies
        Rails.cache.fetch(@movies.cache_key, version: @movies.cache_version) do
          MoviesSerializer.serialize(@movies)
        end
      end
    end
  end
end
