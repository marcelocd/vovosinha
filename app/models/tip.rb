class Tip < ApplicationRecord
  belongs_to :professional
  belongs_to :service_order

  validates :cents, presence: true, numericality: { greater_than: 0, only_integer: true }
end