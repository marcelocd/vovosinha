require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should belong_to(:account) }
    it { should belong_to(:last_updated_by).class_name('User').with_foreign_key('last_updated_by_id').optional }
    it { should belong_to(:deleted_by).class_name('User').with_foreign_key('deleted_by_id').optional }
    it { should have_one(:owned_account).class_name('Account').with_foreign_key('owned_by_id') }
    it { should have_many(:service_orders).with_foreign_key('created_by_id') }
    it { should have_many(:deleted_users).class_name('User').with_foreign_key('deleted_by_id') }
    it { should have_many(:deleted_services).class_name('Service').with_foreign_key('deleted_by_id') }
    it { should have_many(:deleted_service_orders).class_name('ServiceOrder').with_foreign_key('deleted_by_id') }
    it { should have_many(:deleted_clients).class_name('Client').with_foreign_key('deleted_by_id') }
    it { should have_many(:deleted_professionals).class_name('Professional').with_foreign_key('deleted_by_id') }
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_length_of(:email).is_at_most(User::MAX_EMAIL_LENGTH) }
    it { should allow_value('valid@email.com').for(:email) }
    it { should_not allow_value('invalid_email.com').for(:email) }
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username).case_insensitive }
    it { should validate_length_of(:username).is_at_least(User::MIN_USERNAME_LENGTH) }
    it { should validate_length_of(:username).is_at_most(User::MAX_USERNAME_LENGTH) }
    it { should_not allow_value('!NVAL!D').for(:username) }
    it { should validate_presence_of(:first_name) }
    it { should validate_length_of(:first_name).is_at_most(User::MAX_FIRST_NAME_LENGTH) }
    it { should validate_presence_of(:last_name) }
    it { should validate_length_of(:last_name).is_at_most(User::MAX_LAST_NAME_LENGTH) }
    it { should validate_presence_of(:birthdate) }
    it { should define_enum_for(:role).with_values(User::ROLES) }

    let!(:user1) { build(:user, birthdate: Date.tomorrow) }
    it "shouldn't allow birthdate to be tomorrow" do
      user1.valid?
      invalid_birthdate_error_message = I18n.t('activerecord.errors.models.user.attributes.birthdate.invalid')
      expect(user1.errors[:birthdate]).to include(invalid_birthdate_error_message)
    end

    let!(:user2) { build(:user, birthdate: 5.days.from_now) }
    it "shouldn't allow birthdate to be after tomorrow" do
      user2.valid?
      invalid_birthdate_error_message = I18n.t('activerecord.errors.models.user.attributes.birthdate.invalid')
      expect(user2.errors[:birthdate]).to include(invalid_birthdate_error_message)
    end

    let!(:user3) { build(:user, password: nil) }
    it "shouldn't allow password to be blank" do
      user3.valid?
      blank_password_error_message = I18n.t('activerecord.errors.models.user.attributes.password.blank')
      expect(user3.errors[:password]).to include(blank_password_error_message)
    end

    let!(:user4) { build(:user, password: 'a' * (User::MIN_PASSWORD_LENGTH - 1)) }
    it "shouldn't allow password to be too short" do
      user4.valid?
      short_password_error_message = I18n.t('activerecord.errors.models.user.attributes.password.too_short')
      expect(user4.errors[:password]).to include(short_password_error_message)
    end

    let!(:user5) { build(:user, password: 'a' * (User::MAX_PASSWORD_LENGTH + 1)) }
    it "shouldn't allow password to be too long" do
      user5.valid?
      long_password_error_message =
        I18n.t('activerecord.errors.models.user.attributes.password.too_long', maximum: User::MAX_PASSWORD_LENGTH)
      expect(user5.errors[:password]).to include(long_password_error_message)
    end
  end

  describe 'callbacks' do
    let!(:user1) { build(:user, email: 'UPPERCASE@EMAIL.COM') }
    it 'should downcase email before saving' do
      user1.save
      expect(user1.email).to eq('uppercase@email.com')
    end

    let!(:user2) { build(:user, username: 'FULANO123') }
    it 'should downcase username before saving' do
      user2.save
      expect(user2.username).to eq('fulano123')
    end
  end

  describe '#full_name' do
    let!(:user) { build(:user) }
    it 'should return first and last names seperated by a space' do
      expect(user.full_name).to eq("#{user.first_name} #{user.last_name}")
    end
  end
end
