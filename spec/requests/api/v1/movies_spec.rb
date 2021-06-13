# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Movies API', type: :request do
  let(:user) { create(:user) }

  describe 'GET /api/v1/movies' do
    let!(:first_movie) { create(:movie, title: 'Matrix', plot: 'Cyberpunk story of the technological fall of mankind') }
    let!(:second_movie) { create(:movie, title: 'TLOTR', plot: 'Send ring to the fire of Mount Doom in Mordor') }

    before do
      get '/api/v1/movies', params: { user_id: user.id }
    end

    it 'has status code 200' do
      expect(response).to have_http_status(:ok)
    end

    it 'matches valid schema' do
      expect(response).to match_json_schema('v1/movies/index')
    end

    it 'returns expected result' do
      expected_response = { 'movies' => [] }
      [second_movie, first_movie].each do |movie|
        expected_response['movies'] << { 'id' => movie.id, 'title' => movie.title, 'plot' => movie.plot }
      end

      expect(json_response).to match(expected_response)
    end

    context 'when the number of movies is greater than the number of elements per page' do
      before do
        create_list(:movie, 12)
      end

      it 'returns the expected number of movies per page' do
        get '/api/v1/movies', params: { user_id: user.id, page: 1 }

        expect(json_response['movies'].count).to eq(12)
      end

      it 'returns the spare number of movies on the last page' do
        get '/api/v1/movies', params: { user_id: user.id, page: 2 }

        expect(json_response['movies'].count).to eq(2)
      end

      it 'returns 0 movies when passing a page number after the last page' do
        get '/api/v1/movies', params: { user_id: user.id, page: 3 }

        expect(json_response['movies'].count).to eq(0)
      end
    end
  end
end
