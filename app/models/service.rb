class Service < ApplicationRecord
  MIN_NAME_LENGTH = 2
  MAX_NAME_LENGTH = 60
  MAX_DESCRIPTION_LENGTH = 500

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false },
                   length: { minimum: MIN_NAME_LENGTH, maximum: MAX_NAME_LENGTH }
  validates :description, length: { maximum: MAX_DESCRIPTION_LENGTH }
  validates :price_cents, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :commission_percentage, presence: true, numericality: { greater_than: 0 }
  validates :duration_minutes, presence: true, numericality: { only_integer: true, greater_than: 0 }

  belongs_to :service_category

  def commission_cents
    return if price_cents.nil? || commission_percentage.nil?
    (price_cents * (commission_percentage / 100.0)).ceil
  end

  def commission
    return if commission_cents.nil?
    commission_cents / 100.0
  end
end