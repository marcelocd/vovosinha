FactoryBot.define do
  factory :service_order do
    account { create(:account) }
    created_by { create(:user, account: account) }
    client { create(:client, account: account) }
    subtotal_price_cents { Faker::Number.between(from: 100_00, to: 1_000_00) }
    total_commission_cents { (subtotal_price_cents * Faker::Number.between(from: 0.05, to: 0.3)).ceil }
    total_discount_cents { ((subtotal_price_cents - total_commission_cents) * Faker::Number.between(from: 0.0, to: 0.25)).ceil }
    total_price_cents { subtotal_price_cents - total_discount_cents }
    total_tip_cents { (total_price_cents * Faker::Number.between(from: 0.0, to: 0.2)).ceil }
  end
end
