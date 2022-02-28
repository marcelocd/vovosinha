class Service < ApplicationRecord
  scope :active, -> { where(deleted_at: nil) }
  scope :inactive, -> { where.not(deleted_at: nil) }
  
  MIN_NAME_LENGTH = 2
  MAX_NAME_LENGTH = 60
  MAX_DESCRIPTION_LENGTH = 500

  belongs_to :account
  belongs_to :service_category
  belongs_to :deleted_by, class_name: 'User', foreign_key: 'deleted_by_id', optional: true
  belongs_to :last_updated_by, class_name: 'User', foreign_key: 'last_updated_by_id', optional: true

  has_many :service_order_items

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false, scope: :account_id },
                   length: { minimum: MIN_NAME_LENGTH, maximum: MAX_NAME_LENGTH }
  validates :description, length: { maximum: MAX_DESCRIPTION_LENGTH }
  validates :price_cents, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :commission_percentage, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 1 }
  validates :duration_minutes, presence: true, numericality: { only_integer: true, greater_than: 0 }

  validate :account_id_must_be_valid

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

  private

  def account_id_must_be_valid
    return if !account_id.present? ||
              !service_category_id.present? ||
              (account_id == service_category.account_id)
    errors.add(:account_id, :invalid)
  end
end
