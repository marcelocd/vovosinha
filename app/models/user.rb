class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ROLES = %w[admin manager employee]
  EMAIL_REGEXP = URI::MailTo::EMAIL_REGEXP
  USERNAME_REGEXP = /\A[a-zA-Z0-9_.]+\z/
  MAX_EMAIL_LENGTH = 105
  MIN_USERNAME_LENGTH = 8
  MAX_USERNAME_LENGTH = 30
  MIN_PASSWORD_LENGTH = 8
  MAX_PASSWORD_LENGTH = 30
  MAX_FIRST_NAME_LENGTH = 30
  MAX_LAST_NAME_LENGTH = 30

  enum role: ROLES

  before_save :downcase_email
  before_save :downcase_username
  
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    length: { maximum: MAX_EMAIL_LENGTH },
                    format: { with: EMAIL_REGEXP }
  validates :username, presence: true,
                       uniqueness: { case_sensitive: false },
                       length: { minimum: MIN_USERNAME_LENGTH, maximum: MAX_USERNAME_LENGTH },
                       format: { with: USERNAME_REGEXP,
                                 message: I18n.t('activerecord.errors.models.user.attributes.username.invalid_format') }
  validates :password, length: { minimum: MIN_PASSWORD_LENGTH, maximum: MAX_PASSWORD_LENGTH }
  validates :first_name, presence: true, length: { maximum: MAX_FIRST_NAME_LENGTH }
  validates :last_name, presence: true, length: { maximum: MAX_LAST_NAME_LENGTH }
  validates :birthdate, presence: true
  validates :role, inclusion: ROLES

  validate :birthdate_must_be_today_or_before

  has_one_attached :profile_image

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def downcase_email
    self.email = email.downcase if email.present?
  end

  def downcase_username
    self.username = username.downcase if username.present?
  end

  def birthdate_must_be_today_or_before
    if birthdate.present? && birthdate >= Date.tomorrow
      errors.add(:birthdate, :invalid)
    end
  end
end
