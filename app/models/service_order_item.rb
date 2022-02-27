class ServiceOrderItem < ApplicationRecord
  MIN_SERVICE_NAME_LENGTH = 2
  MAX_SERVICE_NAME_LENGTH = 60

  validates :service_name, presence: true, length: { minimum: ServiceOrderItem::MIN_SERVICE_NAME_LENGTH,
                                                     maximum: ServiceOrderItem::MAX_SERVICE_NAME_LENGTH }
  validates :service_price_cents, numericality: { greater_than: 0, only_integer: true }
  validates :service_commission_cents, numericality: { greater_than: 0, only_integer: true }
  validates :service_discount_cents, numericality: { greater_than_or_equal_to: 0, only_integer: true }

  validate :service_commission_cents_is_less_than_or_equal_to_service_price_cents
  validate :service_discount_cents_is_less_than_or_equal_to_service_price_cents_minus_service_commission_cents
  validate :service_order_and_professional_must_belong_to_the_same_account
  validate :service_order_and_service_must_belong_to_the_same_account

  belongs_to :service_order
  belongs_to :service
  belongs_to :professional

  has_one :commission

  def service_price
    service_price_cents.to_i / 100.0
  end

  def service_commission
    service_commission_cents.to_i / 100.0
  end

  def service_discount
    service_discount_cents.to_i / 100.0
  end

  private

  def service_commission_cents_is_less_than_or_equal_to_service_price_cents
    return if service_commission_cents.nil? || service_price_cents.nil?
    if !(service_commission_cents <= service_price_cents)
      errors.add(:service_commission_cents, :invalid)
    end
  end

  def service_discount_cents_is_less_than_or_equal_to_service_price_cents_minus_service_commission_cents
    return if service_discount_cents.nil? || service_price_cents.nil? || service_commission_cents.nil?
    if !(service_discount_cents <= (service_price_cents - service_commission_cents))
      errors.add(:service_discount_cents, :invalid)
    end
  end

  def service_order_and_professional_must_belong_to_the_same_account
    return if !service_order_id.present? ||
              !professional_id.present? ||
              (service_order.account_id == professional.account_id)
    errors.add(:professional_id, :invalid_account_id)
  end

  def service_order_and_service_must_belong_to_the_same_account
    return if !service_order_id.present? ||
              !service_id.present? ||
              (service_order.account_id == service.account_id)
    errors.add(:service_id, :invalid_account_id)
  end
end