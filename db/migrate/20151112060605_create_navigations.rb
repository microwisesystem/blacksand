class CreateNavigations < ActiveRecord::Migration
  def change
    create_table :navigations do |t|
      t.string :name
      t.string :url
      t.integer :position, default: 0
      t.references :page, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
