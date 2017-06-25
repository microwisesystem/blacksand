class CreateFields < ActiveRecord::Migration
  def change
    create_table :fields do |t|
      t.string :name
      t.string :description
      t.string :field_type
      t.references :prototype, index: true, foreign_key: true
      t.string :options
      t.boolean :required, :default => false

      t.timestamps null: false
    end
  end
end
