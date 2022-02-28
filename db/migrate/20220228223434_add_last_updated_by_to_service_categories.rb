class AddLastUpdatedByToServiceCategories < ActiveRecord::Migration[6.1]
  def change
    add_reference :service_categories, :last_updated_by, foreign_key: { to_table: :users }
  end
end
