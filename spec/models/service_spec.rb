require 'rails_helper'

RSpec.describe Service, type: :model do
  describe 'associations' do
    it { should belong_to(:service_category) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should validate_length_of(:name).is_at_least(Service::MIN_NAME_LENGTH) }
    it { should validate_length_of(:name).is_at_most(Service::MAX_NAME_LENGTH) }
    it { should validate_length_of(:description).is_at_most(Service::MAX_DESCRIPTION_LENGTH) }
    it { should validate_numericality_of(:price_cents).is_greater_than(0).only_integer }
    it { should validate_numericality_of(:commission_percentage).is_greater_than(0) }
    it { should validate_numericality_of(:duration_minutes).is_greater_than(0).only_integer }
  end

  describe '#commission' do
    let!(:service) { create(:service, price_cents: 1_000) }
    it 'should bring the price' do
      expect(service.price).to eq(10.0)
    end
  end

  describe '#commission_cents' do
    let!(:service) { create(:service, price_cents: 1_000, commission_percentage: 10.12) }
    it 'should bring the commission cents rounded up' do
      expect(service.commission_cents).to eq(102)
    end
  end

  describe '#commission' do
    let!(:service) { create(:service, price_cents: 1_000, commission_percentage: 10.0) }
    it 'should bring the commission cents rounded up' do
      expect(service.commission).to eq(1.0)
    end
  end
end