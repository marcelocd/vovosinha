require 'rails_helper'

RSpec.describe ServiceCategory, type: :model do
  describe 'associations' do
    it { should belong_to(:account) }
    it { should belong_to(:deleted_by).class_name('User').with_foreign_key('deleted_by_id').optional }
    it { should belong_to(:last_updated_by).class_name('User').with_foreign_key('last_updated_by_id').optional }
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
