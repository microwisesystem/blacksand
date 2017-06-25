class AddOptionsToTemplateAndPrototype < ActiveRecord::Migration
  def change
    add_column :templates, :options, :string
    add_column :prototypes, :options, :string
  end
end
