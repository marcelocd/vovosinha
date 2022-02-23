FactoryBot.define do
  factory :professional do
    account { create(:account) }
    email { Faker::Internet.email }
    ssn { Faker::IDNumber.valid.gsub(/[^\d]+/, '') }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    birthdate { Faker::Date.birthday(max_age: 130) }
    main_phone_number { Faker::Number.decimal_part(digits: Professional::PHONE_NUMBER_LENGTH).to_s }
    second_phone_number { Faker::Number.decimal_part(digits: Professional::PHONE_NUMBER_LENGTH).to_s }
  end
end
