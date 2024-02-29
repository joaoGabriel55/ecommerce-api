# frozen_string_literal: true

class CreateProductsInventoriesJoinTable < ActiveRecord::Migration[7.1]
  def change
    # If you want to add an index for faster querying through this join:
    create_join_table :products, :inventories do |t|
      t.index :product_id
      t.index :inventory_id
    end
  end
end
