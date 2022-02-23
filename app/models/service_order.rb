class ServiceOrder < ApplicationRecord
  validates :subtotal_price_cents, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :total_discount_cents, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :total_price_cents, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :total_commission_cents, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :total_tip_cents, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validate :total_price_cents_is_subtotal_price_cents_minus_total_discount_cents
  validate :total_commission_cents_is_less_than_or_equal_to_total_price_cents
  validate :total_discount_cents_is_less_than_subtotal_price_cents

  belongs_to :account
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
  belongs_to :client

  has_many :service_order_items
  has_many :tips
  has_many :professionals, through: :service_order_items

  accepts_nested_attributes_for :service_order_items

  def subtotal_price
    subtotal_price_cents.to_i / 100.0
  end

  def total_discount
    total_discount_cents.to_i / 100.0
  end

  def total_price
    total_price_cents.to_i / 100.0
  end

  def total_commission
    total_commission_cents.to_i / 100.0
  end

  def total_tip
    total_tip_cents.to_i / 100.0
  end

  private

  def total_price_cents_is_subtotal_price_cents_minus_total_discount_cents
    return if subtotal_price_cents.nil? || total_discount_cents.nil?
    if !(total_price_cents == (subtotal_price_cents - total_discount_cents))
      errors.add(:total_price_cents, :invalid)
    end
  end

  def total_commission_cents_is_less_than_or_equal_to_total_price_cents
    return if total_commission_cents.nil? || total_price_cents.nil?
    if !(total_commission_cents <= total_price_cents)
      errors.add(:total_commission_cents, :invalid)
    end
  end

  def total_discount_cents_is_less_than_subtotal_price_cents
    return if total_discount_cents.nil? || subtotal_price_cents.nil?
    if !(total_discount_cents < subtotal_price_cents)
      errors.add(:total_discount_cents, :invalid)
    end
  end
end
