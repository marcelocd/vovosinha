class CreateServiceOrderItems < ActiveRecord::Migration[6.1]
  def change
    create_table :service_order_items do |t|
      t.references :service_order, index: true, foreign_key: true
      t.references :service, index: true, foreign_key: true
      t.references :professional, index: true, foreign_key: true
      t.string :service_name, default: ''
      t.integer :service_price_cents
      t.integer :service_discount_cents, default: 0
      t.integer :service_commission_cents
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
