require 'rails_helper'

RSpec.describe Account do
  describe 'associations' do
    it { should belong_to(:owned_by).class_name('User').with_foreign_key('owned_by_id').optional }
    it { should belong_to(:deleted_by).class_name('User').with_foreign_key('deleted_by_id').optional }
    it { should have_many(:users) }
    it { should have_many(:clients) }
    it { should have_many(:service_orders) }
    it { should have_many(:service_order_items).through(:service_orders) }
    it { should have_many(:service_categories) }
    it { should have_many(:services) }
    it { should have_many(:professionals) }
    it { should have_many(:commissions).through(:professionals) }
    it { should have_many(:tips).through(:professionals) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should validate_length_of(:name).is_at_least(Account::MIN_NAME_LENGTH) }
    it { should validate_length_of(:name).is_at_most(Account::MAX_NAME_LENGTH) }
  end
end
