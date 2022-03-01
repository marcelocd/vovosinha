FactoryBot.define do
  factory :account do
    company_name { Faker::Lorem.words(number: Account::MIN_COMPANY_NAME_LENGTH)
                               .join(' ')
                               .first(Account::MAX_COMPANY_NAME_LENGTH) }
  end
end
