# frozen_string_literal: true

module Api
  module V1
    module UserAuthenticator
      extend ActiveSupport::Concern

      included do
        before_action :authenticate_user
      end

      def authenticate_user
        @current_user = User.find(params[:user_id])
      rescue ActiveRecord::RecordNotFound
        json_response({ error_message: 'Unauthorized' }, :unauthorized)
      end
    end
  end
end
