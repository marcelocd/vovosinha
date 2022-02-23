FactoryBot.define do
  factory :service_category do
    account { create(:account) }
    name { Faker::Lorem.words(number: 4).join(' ') }
    description { Faker::Lorem.paragraph(sentence_count: 2, random_sentences_to_add: 4)
                              .first(ServiceCategory::MAX_DESCRIPTION_LENGTH) }
  end
end
