# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  email      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  subject { create(:user) }

  it { is_expected.to have_many(:purchases).dependent(:nullify) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to allow_value('valid@email.test').for(:email) }
  it { is_expected.not_to allow_value('incorrect_email').for(:email) }

  describe '#purchases_for_library' do
    let(:owner) { create(:user) }
    let(:season_purchase) { create(:purchase, :for_season, user: owner) }
    let(:movie_purchase) { create(:purchase, :for_movie, user: owner) }

    before do
      season_purchase.update!(expired_at: DateTime.now - 1.hour)
    end

    it 'returns only unexpired purchases for the user' do
      expect(owner.purchases_for_library).to contain_exactly(movie_purchase)
    end
  end
end
