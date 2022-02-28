class AddLastUpdatedByToServices < ActiveRecord::Migration[6.1]
  def change
    add_reference :services, :last_updated_by, foreign_key: { to_table: :users }
  end
end
