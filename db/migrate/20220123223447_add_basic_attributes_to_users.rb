class AddBasicAttributesToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :username, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :birthdate, :date
    add_column :users, :role, :integer, default: 0
    add_column :users, :deleted_at, :datetime
  end
end
