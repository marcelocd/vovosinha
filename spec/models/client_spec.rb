require 'rails_helper'

RSpec.describe Client, type: :model do
  describe 'associations' do
    it { should have_many(:service_orders) }
  end
  
  describe 'validations' do
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_length_of(:email).is_at_most(Client::MAX_EMAIL_LENGTH) }
    it { should allow_value('valid@email.com').for(:email) }
    it { should_not allow_value('invalid_email.com').for(:email) }
    it { should validate_presence_of(:first_name) }
    it { should validate_length_of(:first_name).is_at_most(Client::MAX_FIRST_NAME_LENGTH) }
    it { should validate_presence_of(:last_name) }
    it { should validate_length_of(:last_name).is_at_most(Client::MAX_LAST_NAME_LENGTH) }

    let!(:client1) { build(:client, birthdate: Date.tomorrow) }
    it "shouldn't allow birthdate to be tomorrow" do
      client1.valid?
      invalid_birthdate_error_message = I18n.t('activerecord.errors.models.client.attributes.birthdate.invalid')
      expect(client1.errors[:birthdate]).to include(invalid_birthdate_error_message)
    end

    let!(:client2) { build(:client, birthdate: 5.days.from_now) }
    it "shouldn't allow birthdate to be after tomorrow" do
      client2.valid?
      invalid_birthdate_error_message = I18n.t('activerecord.errors.models.client.attributes.birthdate.invalid')
      expect(client2.errors[:birthdate]).to include(invalid_birthdate_error_message)
    end

    let!(:client3) { build(:client, main_phone_number: '(404)320-8598', second_phone_number: '4043208598') }
    it "shouldn't allow non-nil second_phone_number to be equal to main_phone_number" do
      client3.valid?
      second_phone_number_error_message =
        I18n.t('activerecord.errors.models.client.attributes.second_phone_number.equal_to_main_phone_number')
      expect(client3.errors[:second_phone_number]).to include(second_phone_number_error_message)
    end

    let!(:client4) { build(:client, main_phone_number: '(404)320-85989') }
    it "shouldn't allow main_phone_number number of digits to be different from 10" do
      client4.valid?
      main_phone_number_error_message = I18n.t('activerecord.errors.models.client.attributes.main_phone_number.ten_digits')
      expect(client4.errors[:main_phone_number]).to include(main_phone_number_error_message)
    end

    let!(:client5) { build(:client, second_phone_number: '(404)320-85989') }
    it "shouldn't allow non-nil second_phone_number number of digits to be different from 10" do
      client5.valid?
      second_phone_number_error_message = I18n.t('activerecord.errors.models.client.attributes.second_phone_number.ten_digits')
      expect(client5.errors[:second_phone_number]).to include(second_phone_number_error_message)
    end
  end

  describe 'callbacks' do
    let!(:client1) { build(:client, email: 'UPPERCASE@EMAIL.COM') }
    it 'should downcase email before saving' do
      client1.save
      expect(client1.email).to eq('uppercase@email.com')
    end

    let!(:client2) { build(:client, main_phone_number: '(404)320-8598',) }
    it 'should remove non-digits from main_phone_number before saving' do
      client2.save
      expect(client2.main_phone_number).to eq('4043208598')
    end

    let!(:client3) { build(:client, second_phone_number: '(404)320-8599') }
    it 'should remove non-digits from second_phone_number before saving' do
      client3.save
      expect(client3.second_phone_number).to eq('4043208599')
    end
  end

  describe '#full_name' do
    let!(:client) { build(:client) }
    it 'should return first and last names seperated by a space' do
      expect(client.full_name).to eq("#{client.first_name} #{client.last_name}")
    end
  end
end
