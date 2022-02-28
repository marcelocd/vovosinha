class AddDeletedByToServices < ActiveRecord::Migration[6.1]
  def change
    add_reference :services, :deleted_by, foreign_key: { to_table: :users }
  end
end
