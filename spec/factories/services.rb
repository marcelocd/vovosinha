FactoryBot.define do
  factory :service do
    service_category { create(:service_category) }
    account { service_category.account }
    name { Faker::Lorem.words(number: 2).join(' ') }
    description { Faker::Lorem.paragraph(sentence_count: 2, random_sentences_to_add: 4).first(Service::MAX_DESCRIPTION_LENGTH) }
    price_cents { Faker::Number.between(from: 10_00, to: 100_00) }
    commission_percentage { Faker::Number.between(from: 0.01, to: 1.0) }
    duration_minutes { Faker::Number.between(from: 10, to: 90) }
  end
end
