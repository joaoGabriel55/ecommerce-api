class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.integer :price, default: 0

      t.belongs_to :order
      t.belongs_to :inventory

      t.timestamps
    end
  end
end
