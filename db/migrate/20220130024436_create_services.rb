class CreateServices < ActiveRecord::Migration[6.1]
  def change
    create_table :services do |t|
      t.references :service_category, foreign_key: true
      t.string :name
      t.text :description, default: ''
      t.integer :price_cents
      t.float :commission_percentage
      t.integer :duration_minutes
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
