FactoryBot.define do
  factory :user do
    username { Faker::Internet.username(specifier: User::MIN_USERNAME_LENGTH) }
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: User::MIN_PASSWORD_LENGTH, max_length: User::MAX_PASSWORD_LENGTH) }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    birthdate { Faker::Date.birthday(max_age: 130) }
    role { User::ROLES.sample }
  end
end
