class ServiceCategory < ApplicationRecord
  MIN_NAME_LENGTH = 2
  MAX_NAME_LENGTH = 60
  MAX_DESCRIPTION_LENGTH = 500

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false, scope: :account_id },
                   length: { minimum: MIN_NAME_LENGTH, maximum: MAX_NAME_LENGTH }
  validates :description, length: { maximum: MAX_DESCRIPTION_LENGTH }

  belongs_to :account

  has_many :services
end
