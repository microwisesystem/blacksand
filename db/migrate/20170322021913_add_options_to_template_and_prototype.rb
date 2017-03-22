class AddOptionsToTemplateAndPrototype < ActiveRecord::Migration
  def change
    add_column :templates, :options, :json
    add_column :prototypes, :options, :json
  end
end
