require 'rails_helper'

RSpec.describe Tip do
  describe 'associations' do
    it { should belong_to(:professional) }
    it { should belong_to(:service_order) }
  end

  describe 'validations' do
    it { should validate_presence_of(:cents) }
    it { should validate_numericality_of(:cents).is_greater_than(0).only_integer }

    let!(:account1) { create(:account) }
    let!(:account2) { create(:account) }
    let!(:service_order) { create(:service_order, account: account1) }
    let!(:professional) { create(:professional, account: account2) }
    let!(:tip) { build(:tip, service_order: service_order, professional: professional) }
    it "shouldn't allow service_order and professional to belong to the same account" do
      tip.valid?
      invalid_account_id_message_error =
        I18n.t('activerecord.errors.models.tip.attributes.professional_id.invalid_account_id')
      expect(tip.errors[:professional_id]).to include(invalid_account_id_message_error)
    end
  end
end