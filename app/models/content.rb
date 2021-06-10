# frozen_string_literal: true

# == Schema Information
#
# Table name: contents
#
#  id         :bigint           not null, primary key
#  number     :integer
#  plot       :text(65535)      not null
#  title      :string(255)      not null
#  type       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  parent_id  :bigint
#
# Indexes
#
#  index_contents_on_parent_id  (parent_id)
#
# Foreign Keys
#
#  fk_rails_...  (parent_id => contents.id)
#
class Content < ApplicationRecord
  TYPES_WITH_NUMBER = %w[Episode Season].freeze

  validates :plot, :title, :type, presence: true
  validates :number, presence: true, if: :needs_number?

  private

  def needs_number?
    type.in?(TYPES_WITH_NUMBER)
  end
end
