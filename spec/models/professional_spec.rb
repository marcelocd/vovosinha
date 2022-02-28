require 'rails_helper'

RSpec.describe Professional, type: :model do
  describe 'associations' do
    it { should belong_to(:account) }
    it { should belong_to(:deleted_by).class_name('User').with_foreign_key('deleted_by_id').optional }
    it { should have_many(:service_order_items) }
    it { should have_many(:commissions) }
    it { should have_many(:tips) }
  end

  describe 'validations' do
    it { should validate_uniqueness_of(:email).case_insensitive.scoped_to(:account_id) }
    it { should validate_length_of(:email).is_at_most(Professional::MAX_EMAIL_LENGTH) }
    it { should allow_value('valid@email.com').for(:email) }
    it { should_not allow_value('invalid_email.com').for(:email) }
    it { should validate_presence_of(:ssn) }
    it { should validate_uniqueness_of(:ssn).case_insensitive.scoped_to(:account_id) }
    it { should validate_presence_of(:first_name) }
    it { should validate_length_of(:first_name).is_at_most(Professional::MAX_FIRST_NAME_LENGTH) }
    it { should validate_presence_of(:last_name) }
    it { should validate_length_of(:last_name).is_at_most(Professional::MAX_LAST_NAME_LENGTH) }

    let!(:professional1) { build(:professional, birthdate: Date.tomorrow) }
    it "shouldn't allow birthdate to be tomorrow" do
      professional1.valid?
      invalid_birthdate_error_message = I18n.t('activerecord.errors.models.professional.attributes.birthdate.invalid')
      expect(professional1.errors[:birthdate]).to include(invalid_birthdate_error_message)
    end

    let!(:professional2) { build(:professional, birthdate: 5.days.from_now) }
    it "shouldn't allow birthdate to be after tomorrow" do
      professional2.valid?
      invalid_birthdate_error_message = I18n.t('activerecord.errors.models.professional.attributes.birthdate.invalid')
      expect(professional2.errors[:birthdate]).to include(invalid_birthdate_error_message)
    end

    let!(:professional3) { build(:professional, main_phone_number: '(404)320-8598', second_phone_number: '4043208598') }
    it "shouldn't allow non-nil second_phone_number to be equal to main_phone_number" do
      professional3.valid?
      second_phone_number_error_message =
        I18n.t('activerecord.errors.models.professional.attributes.second_phone_number.equal_to_main_phone_number')
      expect(professional3.errors[:second_phone_number]).to include(second_phone_number_error_message)
    end

    let!(:professional4) { build(:professional, main_phone_number: '(404)320-85989') }
    it "shouldn't allow main_phone_number number of digits to be different from 10" do
      professional4.valid?
      main_phone_number_error_message = I18n.t('activerecord.errors.models.professional.attributes.main_phone_number.ten_digits')
      expect(professional4.errors[:main_phone_number]).to include(main_phone_number_error_message)
    end

    let!(:professional5) { build(:professional, second_phone_number: '(404)320-85989') }
    it "shouldn't allow non-nil second_phone_number number of digits to be different from 10" do
      professional5.valid?
      second_phone_number_error_message = I18n.t('activerecord.errors.models.professional.attributes.second_phone_number.ten_digits')
      expect(professional5.errors[:second_phone_number]).to include(second_phone_number_error_message)
    end

    let!(:professional6) { create(:professional, ssn: '574-92-5596') }
    it 'should remove non-digit characters from ssn' do
      expect(professional6.ssn).to eq('574925596')
    end

    let!(:professional7) { build(:professional, ssn: '574-92-55969') }
    it "shouldn't allow non-nil ssn number of digits to be different from 9" do
      professional7.valid?
      ssn_error_message = I18n.t('activerecord.errors.models.professional.attributes.ssn.nine_digits')
      expect(professional7.errors[:ssn]).to include(ssn_error_message)
    end
  end
end
