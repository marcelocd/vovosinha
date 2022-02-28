class AddLastUpdatedByToClients < ActiveRecord::Migration[6.1]
  def change
    add_reference :clients, :last_updated_by, foreign_key: { to_table: :users }
  end
end
