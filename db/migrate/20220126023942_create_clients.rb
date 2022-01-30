class CreateClients < ActiveRecord::Migration[6.1]
  def change
    create_table :clients do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :main_phone_number
      t.string :second_phone_number
      t.date :birthdate
      t.integer :gender, default: 0
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
