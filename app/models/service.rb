class Service < ApplicationRecord
  MIN_NAME_LENGTH = 2
  MAX_NAME_LENGTH = 60
  MAX_DESCRIPTION_LENGTH = 500

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false, scope: :account_id },
                   length: { minimum: MIN_NAME_LENGTH, maximum: MAX_NAME_LENGTH }
  validates :description, length: { maximum: MAX_DESCRIPTION_LENGTH }
  validates :price_cents, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :commission_percentage, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 1 }
  validates :duration_minutes, presence: true, numericality: { only_integer: true, greater_than: 0 }

  belongs_to :account
  belongs_to :service_category

  has_many :service_order_items

  def price
    return if price_cents.nil?
    price_cents / 100.0
  end

  def commission_cents
    return if price_cents.nil? || commission_percentage.nil?
    (price_cents * commission_percentage).ceil
  end

  def commission
    return if commission_cents.nil?
    commission_cents / 100.0
  end
end
