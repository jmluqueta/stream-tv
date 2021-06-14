# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      include ExceptionHandler
      include Response
      include UserAuthenticator

      before_action :load_user

      def library
        @purchases = @user.purchases_for_library.page(params[:page])

        json_response({ library: cached_library })
      end

      private

      def cached_library
        Rails.cache.fetch(@purchases.cache_key, version: @purchases.cache_version) do
          PurchasesSerializer.serialize_for_user_library(@purchases)
        end
      end

      def load_user
        @user = User.find(params[:id])
      end
    end
  end
end
