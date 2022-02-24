class ChangeServiceOrdersCreatorColumnNameToCreatedBy < ActiveRecord::Migration[6.1]
  def change
    rename_column :service_orders, :creator_id, :created_by_id
  end
end
