FactoryBot.define do
  factory :account do
    name { Faker::Lorem.words(number: Account::MIN_NAME_LENGTH)
                       .join(' ')
                       .first(Account::MAX_NAME_LENGTH) }
  end
end
