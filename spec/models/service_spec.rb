require 'rails_helper'

RSpec.describe Service, type: :model do
  describe 'associations' do
    it { should belong_to(:account) }
    it { should belong_to(:service_category) }
    it { should belong_to(:deleted_by).class_name('User').with_foreign_key('deleted_by_id').optional }
    it { should have_many(:service_order_items) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive.scoped_to(:account_id) }
    it { should validate_length_of(:name).is_at_least(Service::MIN_NAME_LENGTH) }
    it { should validate_length_of(:name).is_at_most(Service::MAX_NAME_LENGTH) }
    it { should validate_length_of(:description).is_at_most(Service::MAX_DESCRIPTION_LENGTH) }
    it { should validate_numericality_of(:price_cents).is_greater_than(0).only_integer }
    it { should validate_numericality_of(:commission_percentage).is_greater_than(0).is_less_than_or_equal_to(1) }
    it { should validate_numericality_of(:duration_minutes).is_greater_than(0).only_integer }

    let!(:account1) { create(:account) }
    let!(:account2) { create(:account) }
    let!(:service_category) { create(:service_category, account: account1) }
    let!(:service) { build(:service, account: account2, service_category: service_category) }
    it "shouldn't allow service and service category to belong to different accounts" do
      service.valid?
      invalid_account_id_message_error = I18n.t('activerecord.errors.models.service.attributes.account_id.invalid')
      expect(service.errors[:account_id]).to include(invalid_account_id_message_error)
    end
  end

  describe '#commission' do
    let!(:service) { create(:service, price_cents: 10_00) }
    it 'should bring the price' do
      expect(service.price).to eq(10.0)
    end
  end

  describe '#commission_cents' do
    let!(:service) { create(:service, price_cents: 10_00, commission_percentage: 0.1012) }
    it 'should bring the commission cents rounded up' do
      expect(service.commission_cents).to eq(102)
    end
  end

  describe '#commission' do
    let!(:service) { create(:service, price_cents: 10_00, commission_percentage: 0.1) }
    it 'should bring the commission cents rounded up' do
      expect(service.commission).to eq(1.0)
    end
  end
end
