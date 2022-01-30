class ServiceCategory < ApplicationRecord
  MIN_NAME_LENGTH = 2
  MAX_NAME_LENGTH = 60
  MAX_DESCRIPTION_LENGTH = 500

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false },
                   length: { minimum: MIN_NAME_LENGTH, maximum: MAX_NAME_LENGTH }
  validates :description, length: { maximum: MAX_DESCRIPTION_LENGTH }

  has_many :services
end