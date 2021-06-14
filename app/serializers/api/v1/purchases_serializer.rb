# frozen_string_literal: true

module Api
  module V1
    class PurchasesSerializer
      def self.serialize_for_user_library(purchases)
        purchases.map do |purchase|
          purchased_content = purchase.purchase_option.purchasable

          content_hash = {
            id: purchased_content.id, title: purchased_content.title,
            plot: purchased_content.plot, type: purchased_content.type,
            quality: purchase.purchase_option.quality
          }

          content_hash.merge!(ContentData.season_data(purchased_content)) if purchased_content.type == 'Season'

          content_hash
        end
      end
    end
  end
end
