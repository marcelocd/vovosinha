require 'rails_helper'

RSpec.describe Commission do
  describe 'associations' do
    it { should belong_to(:professional) }
    it { should belong_to(:service_order_item) }
    it { should have_one(:service_order).through(:service_order_item) }
  end

  describe 'validations' do
    it { should validate_presence_of(:cents) }
    it { should validate_numericality_of(:cents).is_greater_than(0).only_integer }

    let!(:account1) { create(:account) }
    let!(:account2) { create(:account) }
    let!(:service_order) { create(:service_order, account: account1) }
    let!(:service_order_item) { create(:service_order_item, service_order: service_order) }
    let!(:professional) { create(:professional, account: account2) }
    let!(:commission) { build(:commission, service_order: service_order, professional: professional) }
    it "shouldn't allow service_order and professional to belong to the same account" do
      commission.valid?
      invalid_account_id_message_error =
        I18n.t('activerecord.errors.models.commission.attributes.professional_id.invalid_account_id')
      expect(commission.errors[:professional_id]).to include(invalid_account_id_message_error)
    end
  end
end