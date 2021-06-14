# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Seasons API', type: :request do
  let(:user) { create(:user) }

  describe 'GET /api/v1/seasons' do
    let!(:first_season) do
      create(:season, :with_episodes, title: 'Futurama', plot: 'Science fiction animated sitcom', number: 1)
    end
    let!(:second_season) do
      create(:season, :with_episodes, title: 'Rick & Morty', plot: 'Adventures of mad scientist Rick', number: 1)
    end
    let(:expected_response) do
      expected_response = { 'seasons' => [] }

      [second_season, first_season].each_with_index do |season, index|
        expected_response['seasons'] << { 'id' => season.id, 'title' => season.title, 'plot' => season.plot,
                                          'number' => season.number, 'episodes' => [] }

        season.episodes.sorted_by_number.each do |episode|
          expected_response['seasons'][index]['episodes'] << { 'id' => episode.id, 'title' => episode.title,
                                                               'plot' => episode.plot, 'number' => episode.number }
        end
      end

      expected_response
    end

    before do
      get '/api/v1/seasons', params: { user_id: user.id }
    end

    it_behaves_like 'correct get request'

    it 'matches valid schema' do
      expect(response).to match_json_schema('v1/seasons/index')
    end

    it 'returns expected result' do
      expect(json_response).to eq(expected_response)
    end

    context 'when the number of seasons is greater than the number of elements per page' do
      before do
        create_list(:season, 12)
      end

      it 'returns the expected number of seasons per page' do
        get '/api/v1/seasons', params: { user_id: user.id, page: 1 }

        expect(json_response['seasons'].count).to eq(12)
      end

      it 'returns the spare number of seasons on the last page' do
        get '/api/v1/seasons', params: { user_id: user.id, page: 2 }

        expect(json_response['seasons'].count).to eq(2)
      end

      it 'returns 0 seasons when passing a page number after the last page' do
        get '/api/v1/seasons', params: { user_id: user.id, page: 3 }

        expect(json_response['seasons'].count).to eq(0)
      end
    end
  end
end
