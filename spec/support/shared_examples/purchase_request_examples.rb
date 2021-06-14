# frozen_string_literal: true

RSpec.shared_examples 'correct purchase creation request' do
  it_behaves_like 'correct post creation request'

  it 'returns created purchase object' do
    expected_response = { 'purchase' => buyer.purchases.last.as_json }

    expect(json_response).to eq(expected_response)
  end
end

RSpec.shared_examples 'duplicated purchase request' do
  it_behaves_like 'conflict request'

  it 'returns duplicated purchased message' do
    validation_message = I18n.t('activerecord.errors.models.purchase.attributes.base.duplicated_unexpired_purchase')

    expect(json_response['error_message']).to eq("Validation failed: #{validation_message}")
  end
end
