class AddAccountToRelatedTables < ActiveRecord::Migration[6.1]
  def change
    add_reference :users, :account, foreign_key: true
    add_reference :clients, :account, foreign_key: true
    add_reference :service_orders, :account, foreign_key: true
    add_reference :service_categories, :account, foreign_key: true
    add_reference :services, :account, foreign_key: true
    add_reference :professionals, :account, foreign_key: true
  end
end
