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
class Season < Content
  has_many :episodes, foreign_key: 'parent_id', inverse_of: :season, dependent: :destroy
  has_many :purchase_options, as: :purchasable, dependent: :destroy

  scope :sorted_by_created_at, -> { order(created_at: :desc) }
end
