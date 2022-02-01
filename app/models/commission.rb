class Commission < ApplicationRecord
  belongs_to :professional
  belongs_to :service_order_item

  validates :cents, presence: true, numericality: { greater_than: 0, only_integer: true }
end