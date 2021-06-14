# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Purchases API', type: :request do
  let(:user) { create(:user) }
  let(:buyer) { create(:user) }

  describe 'POST /api/v1/purchase_options/:purchase_option_id/purchases' do
    let!(:purchase_option) { create(:purchase_option) }

    context 'when purchase_option does not exists' do
      before do
        post '/api/v1/purchase_options/999/purchases', params: { user_id: user.id, buyer_id: buyer.id }
      end

      it_behaves_like 'not found request'
    end

    context 'when user buyer does not exists' do
      before do
        post "/api/v1/purchase_options/#{purchase_option.id}/purchases", params: { user_id: user.id, buyer_id: 999 }
      end

      it_behaves_like 'not found request'
    end

    context 'with both purchase_option and user created' do
      subject(:purchase_creation_request) do
        post "/api/v1/purchase_options/#{purchase_option.id}/purchases", params: { user_id: user.id,
                                                                                   buyer_id: buyer.id }
      end

      context 'when the buyer doest no have another purchaes' do
        before { purchase_creation_request }

        it_behaves_like 'correct purchase creation request'
      end

      context 'when there is one expired purchased for the same purchase option for the buyer' do
        let!(:expired_purchase) { create(:purchase, purchase_option_id: purchase_option.id, user_id: buyer.id) }

        before do
          expired_purchase.update!(expired_at: DateTime.now - 1.hour)

          purchase_creation_request
        end

        it_behaves_like 'correct purchase creation request'
      end

      context 'when there is one unexpired purchased for the same purchase option for the buyer' do
        before do
          create(:purchase, purchase_option_id: purchase_option.id, user_id: buyer.id)

          purchase_creation_request
        end

        it_behaves_like 'duplicated purchase request'
      end
    end
  end
end
