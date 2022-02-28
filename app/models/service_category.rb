class ServiceCategory < ApplicationRecord
  scope :active, -> { where(deleted_at: nil) }
  scope :inactive, -> { where.not(deleted_at: nil) }
  
  MIN_NAME_LENGTH = 2
  MAX_NAME_LENGTH = 60
  MAX_DESCRIPTION_LENGTH = 500

  belongs_to :account
  belongs_to :deleted_by, class_name: 'User', foreign_key: 'deleted_by_id', optional: true

  has_many :services

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false, scope: :account_id },
                   length: { minimum: MIN_NAME_LENGTH, maximum: MAX_NAME_LENGTH }
  validates :description, length: { maximum: MAX_DESCRIPTION_LENGTH }
end
