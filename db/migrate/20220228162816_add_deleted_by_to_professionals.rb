class AddDeletedByToProfessionals < ActiveRecord::Migration[6.1]
  def change
    add_reference :professionals, :deleted_by, foreign_key: { to_table: :users }
  end
end
