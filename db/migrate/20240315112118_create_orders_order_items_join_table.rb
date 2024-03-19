# frozen_string_literal: true

class CreateOrdersOrderItemsJoinTable < ActiveRecord::Migration[7.1]
  def change
    # If you want to add an index for faster querying through this join:
    create_join_table :orders, :order_items do |t|
      t.index :order_id
      t.index :order_item_id
    end
  end
end
