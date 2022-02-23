require 'rails_helper'

RSpec.describe ServiceCategory, type: :model do
  describe 'associations' do
    it { should belong_to(:account) }
    it { should have_many(:services) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive.scoped_to(:account_id) }
    it { should validate_length_of(:name).is_at_least(ServiceCategory::MIN_NAME_LENGTH) }
    it { should validate_length_of(:name).is_at_most(ServiceCategory::MAX_NAME_LENGTH) }
    it { should validate_length_of(:description).is_at_most(ServiceCategory::MAX_DESCRIPTION_LENGTH) }
  end
end
