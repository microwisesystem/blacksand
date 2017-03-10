class AddOwnerTypeToKindeditorAsset < ActiveRecord::Migration
  def change
    add_column :kindeditor_assets, :owner_type, :string
  end
end
