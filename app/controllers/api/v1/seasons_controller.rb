# frozen_string_literal: true

require_relative '../../../serializers/api/v1/seasons_serializer'

module Api
  module V1
    class SeasonsController < ApplicationController
      include ExceptionHandler
      include Response
      include UserAuthenticator

      def index
        @seasons = Season.sorted_by_created_at.includes(:episodes).page(params[:page])

        json_response({ seasons: cached_seasons })
      end

      private

      def cached_seasons
        Rails.cache.fetch(@seasons.cache_key, version: @seasons.cache_version) do
          SeasonsSerializer.serialize(@seasons)
        end
      end
    end
  end
end
