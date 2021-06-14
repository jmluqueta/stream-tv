# frozen_string_literal: true

module Api
  module V1
    module ExceptionHandler
      extend ActiveSupport::Concern

      included do
        rescue_from ActiveRecord::RecordNotFound do |e|
          json_response({ error_message: e.message }, :not_found)
        end

        rescue_from ActiveRecord::RecordInvalid do |e|
          json_response({ error_message: e.message }, :unprocessable_entity)
        end

        rescue_from ActiveRecord::RecordInvalid do |e|
          json_response({ error_message: e.message }, :conflict)
        end
      end
    end
  end
end
