class Client < ApplicationRecord
  EMAIL_REGEXP = URI::MailTo::EMAIL_REGEXP
  GENDERS = %w[not_informed female male other]
  MAX_EMAIL_LENGTH = 105
  MAX_FIRST_NAME_LENGTH = 30
  MAX_LAST_NAME_LENGTH = 30
  PHONE_NUMBER_LENGTH = 10

  enum gender: GENDERS

  before_save :downcase_email
  before_save :remove_non_digits_from_main_phone_number
  before_save :remove_non_digits_from_second_phone_number
  
  validates :email, uniqueness: { case_sensitive: false, scope: :account_id },
                    length: { maximum: MAX_EMAIL_LENGTH },
                    format: { with: EMAIL_REGEXP }
  validates :first_name, presence: true, length: { maximum: MAX_FIRST_NAME_LENGTH }
  validates :last_name, presence: true, length: { maximum: MAX_LAST_NAME_LENGTH }

  validate :birthdate_must_be_today_or_before
  validate :main_and_second_phone_numbers_must_be_different
  validate :main_phone_number_must_have_ten_digits
  validate :second_phone_number_must_have_ten_digits

  belongs_to :account
  
  has_many :service_orders

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def downcase_email
    self.email = email.downcase if email.present?
  end

  def remove_non_digits_from_main_phone_number
    return if main_phone_number.nil?
    self.main_phone_number = main_phone_number.gsub(/[^\d]+/, '')
  end

  def remove_non_digits_from_second_phone_number
    return if second_phone_number.nil?
    self.second_phone_number = second_phone_number.gsub(/[^\d]+/, '')
  end

  def birthdate_must_be_today_or_before
    if birthdate.present? && birthdate >= Date.tomorrow
      errors.add(:birthdate, :invalid)
    end
  end

  def main_and_second_phone_numbers_must_be_different
    return if main_phone_number.nil? || second_phone_number.nil?
    if main_phone_number.gsub(/[^\d]+/, '') == second_phone_number.gsub(/[^\d]+/, '')
      errors.add(:second_phone_number, :equal_to_main_phone_number)
    end
  end

  def main_phone_number_must_have_ten_digits
    return if main_phone_number.nil?
    if main_phone_number.gsub(/[^\d]+/, '').length != PHONE_NUMBER_LENGTH
      errors.add(:main_phone_number, :ten_digits)
    end
  end

  def second_phone_number_must_have_ten_digits
    return if second_phone_number.nil?
    if second_phone_number.gsub(/[^\d]+/, '').length != PHONE_NUMBER_LENGTH
      errors.add(:second_phone_number, :ten_digits)
    end
  end
end
