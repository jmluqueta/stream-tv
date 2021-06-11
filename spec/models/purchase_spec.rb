# frozen_string_literal: true

# == Schema Information
#
# Table name: purchases
#
#  id                 :bigint           not null, primary key
#  expired_at         :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  purchase_option_id :bigint           not null
#  user_id            :bigint           not null
#
# Indexes
#
#  index_purchases_on_purchase_option_id  (purchase_option_id)
#  index_purchases_on_user_id             (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (purchase_option_id => purchase_options.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Purchase, type: :model do
  it { is_expected.to belong_to(:purchase_option) }
  it { is_expected.to belong_to(:user) }

  describe '#uniqueness_by_user_and_purchase_option' do
    let!(:purchase) { create(:purchase) }
    let(:repeated_purchase) { create(:purchase, purchase_option: purchase.purchase_option, user: purchase.user) }

    context 'when user purchases the same content twice before the first purchase expires' do
      it 'raises a validation error' do
        validation_message = I18n.t('activerecord.errors.models.purchase.attributes.base.duplicated_unexpired_purchase')

        expect { repeated_purchase }
          .to raise_error(ActiveRecord::RecordInvalid, "Validation failed: #{validation_message}")
      end
    end

    context 'when user purchases the same content twice after the first purchase expires' do
      it 'creates the new purchase' do
        purchase.update!(expired_at: DateTime.now - 1.hour)

        expect { repeated_purchase }.to change(described_class, :count)
      end
    end
  end
end
