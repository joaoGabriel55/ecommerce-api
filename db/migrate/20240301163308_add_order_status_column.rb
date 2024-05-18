# frozen_string_literal: true

class AddOrderStatusColumn < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :status, :string
  end
end
