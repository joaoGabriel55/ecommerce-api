class CreateInventories < ActiveRecord::Migration[7.1]
  def change
    create_table :inventories do |t|
      t.string :supplier, null: false, index: { unique: true }
      t.integer :quantity, null: false, default: 0

      t.references :product, foreign_key: true, null: false

      t.timestamps
    end
  end
end
