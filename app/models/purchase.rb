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
class Purchase < ApplicationRecord
  DAYS_TO_EXPIRE = 2

  belongs_to :purchase_option
  belongs_to :user

  scope :unexpired, -> { where('expired_at > ?', DateTime.now) }

  validate :uniqueness_by_user_and_purchase_option, on: :create

  before_validation :set_expired_at, on: :create

  private

  def set_expired_at
    self.expired_at = DateTime.now + DAYS_TO_EXPIRE.days
  end

  def uniqueness_by_user_and_purchase_option
    return if Purchase.unexpired.where(user_id: user_id, purchase_option_id: purchase_option_id).blank?

    errors.add(:base, :duplicated_unexpired_purchase)
  end
end
