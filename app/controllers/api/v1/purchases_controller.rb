# frozen_string_literal: true

module Api
  module V1
    class PurchasesController < ApplicationController
      include ExceptionHandler
      include Response
      include UserAuthenticator

      before_action :load_purchase_option, :load_user

      def create
        @purchase = @user.purchases.create!(purchase_option_id: @purchase_option.id)

        json_response({ purchase: @purchase }, :created)
      end

      private

      def load_purchase_option
        @purchase_option = PurchaseOption.find(params[:purchase_option_id])
      end

      def load_user
        @user = User.find(params[:buyer_id])
      end
    end
  end
end
