class ChangeAccountsNameColumnNameToCompanyName < ActiveRecord::Migration[6.1]
  def change
    rename_column :accounts, :name, :company_name
  end
end
