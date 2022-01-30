class CreateProfessionals < ActiveRecord::Migration[6.1]
  def change
    create_table :professionals do |t|
      t.string :first_name
      t.string :last_name
      t.string :ssn
      t.date :birthdate
      t.string :email
      t.string :main_phone_number
      t.string :second_phone_number
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
