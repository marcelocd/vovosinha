class CreateAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts do |t|
      t.references :owned_by, foreign_key: { to_table: :users }
      t.string :name

      t.timestamps
    end
  end
end
