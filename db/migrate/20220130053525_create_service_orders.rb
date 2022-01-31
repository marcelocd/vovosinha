class CreateServiceOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :service_orders do |t|
      t.references :creator, index: true, foreign_key: { to_table: :users }
      t.references :client, index: true, foreign_key: true
      t.integer :subtotal_price_cents
      t.integer :total_discount_cents, default: 0
      t.integer :total_price_cents
      t.integer :total_commission_cents
      t.integer :total_tip_cents, default: 0
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
