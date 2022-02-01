require 'rails_helper'

RSpec.describe Tip do
  describe 'associations' do
    it { should belong_to(:professional) }
    it { should belong_to(:service_order) }
  end

  describe 'validations' do
    it { should validate_presence_of(:cents) }
    it { should validate_numericality_of(:cents).is_greater_than(0).only_integer }
  end
end