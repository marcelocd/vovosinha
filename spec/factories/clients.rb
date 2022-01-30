FactoryBot.define do
  factory :client do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    birthdate { Faker::Date.birthday(max_age: 130) }
    main_phone_number { Faker::Number.decimal_part(digits: 10).to_s }
    second_phone_number { Faker::Number.decimal_part(digits: 10).to_s }
    gender { Client::GENDERS.sample }
  end
end
