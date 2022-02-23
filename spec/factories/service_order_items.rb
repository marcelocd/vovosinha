FactoryBot.define do
  factory :service_order_item do
    service { create(:service) }
    service_order { create(:service_order, account: service.account) }
    professional { create(:professional, account: service.account ) }
    service_name { service.name }
    service_price_cents { service.price_cents }
    service_commission_cents { service.commission_cents }
    service_discount_cents { ((service_price_cents - service_commission_cents) * Faker::Number.between(from: 0.0, to: 0.25)).ceil }
  end
end
