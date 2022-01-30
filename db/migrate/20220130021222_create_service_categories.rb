class CreateServiceCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :service_categories do |t|
      t.string :name
      t.text :description, default: ''
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
