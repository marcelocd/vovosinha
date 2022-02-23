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