class Account < ApplicationRecord
  MIN_NAME_LENGTH = 3
  MAX_NAME_LENGTH = 60

  belongs_to :owned_by, class_name: 'User',
                        foreign_key: 'owned_by_id',
                        optional: true

  has_many :users
  has_many :clients
  has_many :service_categories
  has_many :services
  has_many :service_orders
  has_many :service_order_items, through: :service_orders
  has_many :professionals
  has_many :commissions, through: :professionals
  has_many :tips, through: :professionals

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false },
                   length: { minimum: MIN_NAME_LENGTH, maximum: MAX_NAME_LENGTH }
end
