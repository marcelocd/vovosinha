FactoryBot.define do
  factory :service_category do
    name { Faker::Lorem.word }
    description { Faker::Lorem.paragraph(sentence_count: 2, random_sentences_to_add: 4)
                              .first(ServiceCategory::MAX_DESCRIPTION_LENGTH) }
  end
end