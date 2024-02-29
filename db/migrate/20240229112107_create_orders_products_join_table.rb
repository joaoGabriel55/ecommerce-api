# frozen_string_literal: true

class CreateOrdersProductsJoinTable < ActiveRecord::Migration[7.1]
  def change
    # If you want to add an index for faster querying through this join:
    create_join_table :orders, :products do |t|
      t.index :order_id
      t.index :product_id
    end
  end
end
