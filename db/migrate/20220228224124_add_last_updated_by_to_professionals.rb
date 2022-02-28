class AddLastUpdatedByToProfessionals < ActiveRecord::Migration[6.1]
  def change
    add_reference :professionals, :last_updated_by, foreign_key: { to_table: :users }
  end
end
