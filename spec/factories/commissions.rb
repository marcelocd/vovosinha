FactoryBot.define do
  factory :commission do
    service_order_item { create(:service_order_item) }
    professional { create(:professional, account: service_order_item.account) }
    cents { service_order_item.service_commission_cents }
  end
end
