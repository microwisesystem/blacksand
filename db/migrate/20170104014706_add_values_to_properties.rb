class AddValuesToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :values, :string
  end
end
