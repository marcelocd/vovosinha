FactoryBot.define do
  factory :tip do
    service_order { create(:service_order) }
    professional { create(:professional, account: service_order.account) }
    cents { Faker::Number.between(from: 10_00, to: 100_00) }
  end
end
