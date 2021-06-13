# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'MoviesAndSeasons API', type: :request do
  let(:user) { create(:user) }

  describe 'GET /api/v1/movies_and_seasons' do
    let!(:season) do
      create(:season, :with_episodes, title: 'Futurama', plot: 'Science fiction animated sitcom', number: 1)
    end
    let!(:movie) { create(:movie, title: 'TLOTR', plot: 'Send ring to the fire of Mount Doom in Mordor') }
    let(:expected_response) do
      expected_response = {
        'movies_and_seasons' => [
          {
            'id' => movie.id,
            'title' => movie.title,
            'plot' => movie.plot,
            'type' => movie.type
          },
          {
            'id' => season.id,
            'title' => season.title,
            'plot' => season.plot,
            'type' => season.type,
            'number' => season.number,
            'episodes' => []
          }
        ]
      }

      season.episodes.sorted_by_number.each do |episode|
        expected_response['movies_and_seasons'][1]['episodes'] << { 'id' => episode.id, 'title' => episode.title,
                                                                    'plot' => episode.plot, 'number' => episode.number }
      end

      expected_response
    end

    before do
      get '/api/v1/movies_and_seasons', params: { user_id: user.id }
    end

    it 'has status code 200' do
      expect(response).to have_http_status(:ok)
    end

    it 'matches valid schema' do
      expect(response).to match_json_schema('v1/movies_and_seasons/index')
    end

    it 'returns expected result' do
      expect(json_response).to eq(expected_response)
    end

    context 'when the number of movies and seasons is greater than the number of elements per page' do
      before do
        create_list(:movie, 6)
        create_list(:season, 6)
      end

      it 'returns the expected number of movies and seasons per page' do
        get '/api/v1/movies_and_seasons', params: { user_id: user.id, page: 1 }

        expect(json_response['movies_and_seasons'].count).to eq(12)
      end

      it 'returns the spare number of movies and seasons on the last page' do
        get '/api/v1/movies_and_seasons', params: { user_id: user.id, page: 2 }

        expect(json_response['movies_and_seasons'].count).to eq(2)
      end

      it 'returns 0 movies and seasons when passing a page number after the last page' do
        get '/api/v1/movies_and_seasons', params: { user_id: user.id, page: 3 }

        expect(json_response['movies_and_seasons'].count).to eq(0)
      end
    end
  end
end
