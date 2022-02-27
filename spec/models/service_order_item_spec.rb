require 'rails_helper'

RSpec.describe ServiceOrderItem, type: :model do
  describe 'associations' do
    it { should belong_to(:service) }
    it { should belong_to(:service_order) }
    it { should belong_to(:professional) }
    it { should have_one(:commission) }
  end 

  describe 'validations' do
    it { should validate_presence_of(:service_name) }
    it { should validate_length_of(:service_name).is_at_least(ServiceOrderItem::MIN_SERVICE_NAME_LENGTH) }
    it { should validate_length_of(:service_name).is_at_most(ServiceOrderItem::MAX_SERVICE_NAME_LENGTH) }
    it { should validate_numericality_of(:service_price_cents).is_greater_than(0).only_integer }
    it { should validate_numericality_of(:service_commission_cents).is_greater_than(0).only_integer }
    it { should validate_numericality_of(:service_discount_cents).is_greater_than_or_equal_to(0).only_integer }

    let!(:service_order_item1) { build(:service_order_item,
                                       service_price_cents: 100_00,
                                       service_commission_cents: 101_00) }
    it "shouldn't allow service_commission_cents to be greater than service_price_cents" do
      service_order_item1.valid?
      service_commission_cents_error_message =
        I18n.t('activerecord.errors.models.service_order_item.attributes.service_commission_cents.invalid')
      expect(service_order_item1.errors[:service_commission_cents]).to include(service_commission_cents_error_message)
    end

    let!(:service_order_item2) { build(:service_order_item,
                                       service_price_cents: 100_00,
                                       service_commission_cents: 20_00,
                                       service_discount_cents: 81_00) }
    it "shouldn't allow service_discount_cents to be greater than (service_price_cents - service_commission_cents)" do
      service_order_item2.valid?
      service_discount_cents_error_message =
        I18n.t('activerecord.errors.models.service_order_item.attributes.service_discount_cents.invalid')
      expect(service_order_item2.errors[:service_discount_cents]).to include(service_discount_cents_error_message)
    end

    let!(:account1) { create(:account) }
    let!(:account2) { create(:account) }
    let!(:service_order) { create(:service_order, account: account1) }
    let!(:service) { create(:service, account: account2) }
    let!(:service_order_item3) { build(:service_order_item, service_order: service_order, service: service) }
    it "shouldn't allow service_order and service to have different account_ids" do
      service_order_item3.valid?
      invalid_account_id_message_error =
        I18n.t('activerecord.errors.models.service_order_item.attributes.service_id.invalid_account_id')
      expect(service_order_item3.errors[:service_id]).to include(invalid_account_id_message_error)
    end

    let!(:professional) { create(:professional, account: account2) }
    let!(:service_order_item4) { build(:service_order_item, service_order: service_order, professional: professional) }
    it "shouldn't allow service_order and service to have different account_ids" do
      service_order_item4.valid?
      invalid_account_id_message_error =
        I18n.t('activerecord.errors.models.service_order_item.attributes.professional_id.invalid_account_id')
      expect(service_order_item4.errors[:professional_id]).to include(invalid_account_id_message_error)
    end
  end

  describe '#service_price' do
    let!(:service_order_item) { create(:service_order_item) }
    it 'should bring service_order_item divided by 100.0' do
      expect(service_order_item.service_price).to eq(service_order_item.service_price_cents / 100.0)
    end
  end

  describe '#service_commission' do
    let!(:service_order_item) { create(:service_order_item) }
    it 'should bring service_order_item divided by 100.0' do
      expect(service_order_item.service_commission).to eq(service_order_item.service_commission_cents / 100.0)
    end
  end

  describe '#service_discount' do
    let!(:service_order_item) { create(:service_order_item) }
    it 'should bring service_order_item divided by 100.0' do
      expect(service_order_item.service_discount).to eq(service_order_item.service_discount_cents / 100.0)
    end
  end
end