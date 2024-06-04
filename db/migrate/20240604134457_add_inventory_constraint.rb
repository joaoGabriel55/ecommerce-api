# frozen_string_literal: true

class AddInventoryConstraint < ActiveRecord::Migration[7.1]
  def change
    add_check_constraint :inventories, 'quantity >= 0', name: 'quantity_check'
  end
end
