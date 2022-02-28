class AddDeletedByToServiceOrders < ActiveRecord::Migration[6.1]
  def change
    add_reference :service_orders, :deleted_by, foreign_key: { to_table: :users }
  end
end
