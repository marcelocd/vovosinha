require 'rails_helper'

RSpec.describe ServiceOrder, type: :model do
  describe 'associations' do
    it { should belong_to(:account) }
    it { should belong_to(:created_by).class_name('User').with_foreign_key('created_by_id') }
    it { should belong_to(:client) }
    it { should have_many(:service_order_items) }
    it { should have_many(:tips) }
    it { should have_many(:professionals).through(:service_order_items) }
  end

  describe 'validations' do
    it { should validate_numericality_of(:subtotal_price_cents).is_greater_than(0).only_integer }
    it { should validate_numericality_of(:total_discount_cents).is_greater_than_or_equal_to(0).only_integer }
    it { should validate_numericality_of(:total_price_cents).is_greater_than(0).only_integer }
    it { should validate_numericality_of(:total_commission_cents).is_greater_than(0).only_integer }
    it { should validate_numericality_of(:total_tip_cents).is_greater_than_or_equal_to(0).only_integer }

    let!(:service_order1) { build(:service_order,
                                 total_price_cents: 100_00,
                                 subtotal_price_cents: 100_00,
                                 total_discount_cents: 10_00) }
    it "shouldn't allow total_price_cents to be different from (subtotal_price_cents - total_discount_cents)" do
      service_order1.valid?
      invalid_total_price_cents_error_message =
        I18n.t('activerecord.errors.models.service_order.attributes.total_price_cents.invalid')
      expect(service_order1.errors[:total_price_cents]).to include(invalid_total_price_cents_error_message)
    end

    let!(:service_order2) { build(:service_order) }
    it "shouldn't allow total_commission_cents to be greater than total_price_cents" do
      service_order2.total_commission_cents = service_order2.total_price_cents + 1
      service_order2.valid?
      invalid_total_commission_cents_error_message =
        I18n.t('activerecord.errors.models.service_order.attributes.total_commission_cents.invalid')
      expect(service_order2.errors[:total_commission_cents]).to include(invalid_total_commission_cents_error_message)
    end

    let!(:service_order3) { build(:service_order) }
    it "shouldn't allow total_discount_cents to be greater than or equal to subtotal_price_cents" do
      service_order3.total_discount_cents = service_order3.subtotal_price_cents
      service_order3.valid?
      invalid_total_discount_cents_error_message =
        I18n.t('activerecord.errors.models.service_order.attributes.total_discount_cents.invalid')
      expect(service_order3.errors[:total_discount_cents]).to include(invalid_total_discount_cents_error_message)
    end

    let!(:account1) { create(:account) }
    let!(:account2) { create(:account) }
    let!(:creator) { create(:user, account: account1) }
    let!(:service_order4) { build(:service_order, account: account2, created_by: creator) }
    it "shouldn't allow service_order and created_by to have different account_ids" do
      service_order4.valid?
      invalid_account_id_message_error = I18n.t('activerecord.errors.models.service_order.attributes.account_id.invalid')
      expect(service_order4.errors[:account_id]).to include(invalid_account_id_message_error)
    end

    let!(:service_order5) { build(:service_order, account: account2) }
    it "shouldn't allow service_order's and client's account_id to be different" do
      service_order4.valid?
      invalid_account_id_message_error = I18n.t('activerecord.errors.models.service_order.attributes.account_id.invalid')
      expect(service_order4.errors[:account_id]).to include(invalid_account_id_message_error)
    end
  end

  describe '#subtotal_price' do
    let!(:service_order) { create(:service_order) }
    it 'should bring subtotal_price_cents divided by 100.0' do
      expect(service_order.subtotal_price).to eq(service_order.subtotal_price_cents / 100.0)
    end
  end

  describe '#total_discount' do
    let!(:service_order) { create(:service_order) }
    it 'should bring total_discount_cents divided by 100.0' do
      expect(service_order.total_discount).to eq(service_order.total_discount_cents / 100.0)
    end
  end

  describe '#total_price' do
    let!(:service_order) { create(:service_order) }
    it 'should bring total_price_cents divided by 100.0' do
      expect(service_order.total_price).to eq(service_order.total_price_cents / 100.0)
    end
  end

  describe '#total_commission' do
    let!(:service_order) { create(:service_order) }
    it 'should bring total_commission_cents divided by 100.0' do
      expect(service_order.total_commission).to eq(service_order.total_commission_cents / 100.0)
    end
  end

  describe '#total_tip' do
    let!(:service_order) { create(:service_order) }
    it 'should bring total_tip_cents divided by 100.0' do
      expect(service_order.total_tip).to eq(service_order.total_tip_cents / 100.0)
    end
  end
end
