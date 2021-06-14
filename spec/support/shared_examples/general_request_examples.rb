# frozen_string_literal: true

RSpec.shared_examples 'correct get request' do
  it 'returns status code 200' do
    expect(response).to have_http_status(:ok)
  end
end

RSpec.shared_examples 'correct post creation request' do
  it 'returns status code 201' do
    expect(response).to have_http_status(:created)
  end
end

RSpec.shared_examples 'not found request' do
  it 'returns status code 404' do
    expect(response).to have_http_status(:not_found)
  end
end

RSpec.shared_examples 'conflict request' do
  it 'returns status code 409' do
    expect(response).to have_http_status(:conflict)
  end
end
