class AddDeletedByToClients < ActiveRecord::Migration[6.1]
  def change
    add_reference :clients, :deleted_by, foreign_key: { to_table: :users }
  end
end
