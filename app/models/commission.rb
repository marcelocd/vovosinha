class Commission < ApplicationRecord
  belongs_to :professional
  belongs_to :service_order_item

  has_one :service_order, through: :service_order_item

  validates :cents, presence: true, numericality: { greater_than: 0, only_integer: true }

  validate :service_order_and_professional_must_belong_to_the_same_account

  private

  def service_order_and_professional_must_belong_to_the_same_account
    return if !service_order_item_id.present? ||
              !service_order_item.service_order_id.present? ||
              !professional_id.present? ||
              (service_order.account_id == professional.account_id)
    errors.add(:professional_id, :invalid_account_id)
  end
end