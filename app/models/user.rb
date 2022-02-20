class User < ApplicationRecord
  scope :active, -> { where(deleted_at: nil) }
  scope :inactive, -> { where.not(deleted_at: nil) }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ROLES = %w[admin manager employee]
  EMAIL_REGEXP = URI::MailTo::EMAIL_REGEXP
  USERNAME_REGEXP = /\A[a-zA-Z0-9_.]+\z/
  MAX_EMAIL_LENGTH = 105
  MIN_USERNAME_LENGTH = 6
  MAX_USERNAME_LENGTH = 30
  MIN_PASSWORD_LENGTH = 8
  MAX_PASSWORD_LENGTH = ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED
  MAX_FIRST_NAME_LENGTH = 30
  MAX_LAST_NAME_LENGTH = 30

  enum role: ROLES

  belongs_to :deleted_by, class_name: 'User', foreign_key: 'deleted_by_id', optional: true
  
  has_many :service_orders, foreign_key: 'creator_id'
  has_many :deleted_users, class_name: 'User', foreign_key: 'deleted_by_id'

  has_one_attached :profile_image
  
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false, scope: :deleted_at },
                    length: { maximum: MAX_EMAIL_LENGTH },
                    format: { with: EMAIL_REGEXP }
  validates :username, presence: true,
                       uniqueness: { case_sensitive: false, scope: :deleted_at },
                       length: { minimum: MIN_USERNAME_LENGTH, maximum: MAX_USERNAME_LENGTH },
                       format: { with: USERNAME_REGEXP,
                                 message: I18n.t('activerecord.errors.models.user.attributes.username.invalid_format') }
  validates :first_name, presence: true, length: { maximum: MAX_FIRST_NAME_LENGTH }
  validates :last_name, presence: true, length: { maximum: MAX_LAST_NAME_LENGTH }
  validates :birthdate, presence: true
  validates :role, inclusion: ROLES

  validate :password_must_be_present
  validate :password_length_must_be_valid
  validate :birthdate_must_be_today_or_before

  before_save :downcase_email
  before_save :downcase_username

  def active
    deleted_at.nil?
  end

  def active?
    active
  end

  def inactive
    deleted_at.present?
  end

  def inactive?
    inactive
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.find_for_database_authentication conditions = {}
    find_by(username: conditions[:email]) || find_by(email: conditions[:email])
  end

  private

  def downcase_email
    self.email = email.downcase if email.present?
  end

  def downcase_username
    self.username = username.downcase if username.present?
  end

  def password_must_be_present
    return if id.present?
    errors.add(:password, :blank) if password.blank?
  end

  def password_length_must_be_valid
    return if password.nil?
    if password.length < MIN_PASSWORD_LENGTH
      errors.add(:password, :too_short)
    elsif password.length > MAX_PASSWORD_LENGTH
      errors.add(:password, :too_long, maximum: MAX_PASSWORD_LENGTH)
    end
  end

  def birthdate_must_be_today_or_before
    if birthdate.present? && birthdate >= Date.tomorrow
      errors.add(:birthdate, :invalid)
    end
  end
end
