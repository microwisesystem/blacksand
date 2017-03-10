class AddOwnerTypeToKindeditorAsset < ActiveRecord::Migration[5.0]
  def change
    add_column :kindeditor_assets, :owner_type, :string
  end
end
