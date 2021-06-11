# frozen_string_literal: true

# == Schema Information
#
# Table name: purchase_options
#
#  id               :bigint           not null, primary key
#  price            :decimal(8, 2)    not null
#  purchasable_type :string(255)      not null
#  quality          :string(255)      not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  purchasable_id   :bigint           not null
#
# Indexes
#
#  index_purchase_options_on_purchasable  (purchasable_type,purchasable_id)
#
require 'rails_helper'

RSpec.describe PurchaseOption, type: :model do
  it { is_expected.to belong_to(:purchasable) }
  it { is_expected.to have_many(:purchases).dependent(:nullify) }

  it { is_expected.to validate_presence_of(:quality) }
  it { is_expected.to validate_presence_of(:price) }
  it { is_expected.to validate_inclusion_of(:quality).in_array(described_class::ALLOWED_VIDEO_QUALITIES) }
end
