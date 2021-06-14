# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let(:user) { create(:user) }
  let(:owner) { create(:user) }

  describe 'GET /api/v1/users/:id/library' do
    let!(:season_purchase_option) { create(:purchase_option, :for_season) }
    let!(:movie_purchase_option) { create(:purchase_option, :for_movie) }

    let(:expected_response) do
      movie = movie_purchase_option.purchasable
      season = season_purchase_option.purchasable

      expected_response = {
        'library' => [
          {
            'id' => season.id, 'title' => season.title, 'plot' => season.plot,
            'type' => season.type, 'quality' => season_purchase_option.quality,
            'number' => season.number, 'episodes' => []
          },
          {
            'id' => movie.id, 'title' => movie.title, 'plot' => movie.plot,
            'type' => movie.type, 'quality' => movie_purchase_option.quality
          }
        ]
      }

      season.episodes.sorted_by_number.each do |episode|
        expected_response['library'][0]['episodes'] << { 'id' => episode.id, 'title' => episode.title,
                                                         'plot' => episode.plot, 'number' => episode.number }
      end

      expected_response
    end

    context 'with id of an owner that does not exist' do
      before do
        get '/api/v1/users/999/library', params: { user_id: user.id }
      end

      it_behaves_like 'not found request'
    end

    context 'with id of an owner that exists' do
      before do
        create(:purchase, purchase_option: season_purchase_option, user: owner)
        create(:purchase, purchase_option: movie_purchase_option, user: owner)

        get "/api/v1/users/#{owner.id}/library", params: { user_id: user.id }
      end

      it_behaves_like 'correct get request'

      it 'matches valid schema' do
        expect(response).to match_json_schema('v1/users/library')
      end

      it 'returns expected result' do
        expect(json_response).to eq(expected_response)
      end

      context 'when the owner has expired purchases' do
        let(:expected_response) do
          movie = movie_purchase_option.purchasable

          {
            'library' => [
              {
                'id' => movie.id, 'title' => movie.title, 'plot' => movie.plot,
                'type' => movie.type, 'quality' => movie_purchase_option.quality
              }
            ]
          }
        end

        before do
          purchased_season = owner.purchases.first
          purchased_season.update!(expired_at: DateTime.now - 1)

          get "/api/v1/users/#{owner.id}/library", params: { user_id: user.id }
        end

        it 'does not return the expired purchases' do
          expect(json_response).to eq(expected_response)
        end
      end

      context 'when the number of purchases is greater than the number of elements per page' do
        before do
          create_list(:purchase, 12, user: owner)
        end

        it 'returns the expected number of purchases per page' do
          get "/api/v1/users/#{owner.id}/library", params: { user_id: user.id, page: 1 }

          expect(json_response['library'].count).to eq(12)
        end

        it 'returns the spare number of purchases on the last page' do
          get "/api/v1/users/#{owner.id}/library", params: { user_id: user.id, page: 2 }

          expect(json_response['library'].count).to eq(2)
        end

        it 'returns 0 purchases when passing a page number after the last page' do
          get "/api/v1/users/#{owner.id}/library", params: { user_id: user.id, page: 3 }

          expect(json_response['library'].count).to eq(0)
        end
      end
    end
  end
end
