class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.string :en_name
      t.text :content
      t.integer :parent_id
      t.references :template, index: true, foreign_key: true
      t.references :prototype, index: true, foreign_key: true
      t.integer :position, default: 0

      t.timestamps null: false
    end
  end
end
