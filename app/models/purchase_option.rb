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
class PurchaseOption < ApplicationRecord
  ALLOWED_VIDEO_QUALITIES = %w[SD HD].freeze

  belongs_to :purchasable, polymorphic: true
  has_many :purchases, dependent: :nullify

  validates :quality, :price, presence: true
  validates :quality, inclusion: { in: ALLOWED_VIDEO_QUALITIES }
end
