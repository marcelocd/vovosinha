FactoryBot.define do
  factory :service do
    service_category { create(:service_category) }
    name { Faker::Lorem.word }
    description { Faker::Lorem.paragraph(sentence_count: 2, random_sentences_to_add: 4).first(Service::MAX_DESCRIPTION_LENGTH) }
    price_cents { Faker::Number.between(from: 1000, to: 10_000) }
    commission_percentage { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    duration_minutes { Faker::Number.between(from: 10, to: 90) }
  end
end