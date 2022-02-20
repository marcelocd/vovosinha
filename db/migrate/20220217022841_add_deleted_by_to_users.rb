class AddDeletedByToUsers < ActiveRecord::Migration[6.1]
  def change
    add_reference :users, :deleted_by, foreign_key: { to_table: :users }
  end
end