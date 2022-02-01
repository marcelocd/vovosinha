class CreateTips < ActiveRecord::Migration[6.1]
  def change
    create_table :tips do |t|
      t.references :professional, foreign_key: true
      t.references :service_order, foreign_key: true
      t.integer :cents
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
