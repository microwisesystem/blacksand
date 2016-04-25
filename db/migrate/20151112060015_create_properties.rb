class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.text :value
      t.references :page, index: true, foreign_key: true
      t.references :field, index: true, foreign_key: true
      t.string  :type
      t.json :gallery
      t.string :image, :string

      t.timestamps null: false
    end
  end
end
