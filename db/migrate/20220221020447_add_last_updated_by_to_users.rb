class AddLastUpdatedByToUsers < ActiveRecord::Migration[6.1]
  def change
    add_reference :users, :last_updated_by, foreign_key: { to_table: :users }
  end
end
