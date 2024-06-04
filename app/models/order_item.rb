# frozen_string_literal: true

class OrderItem < ApplicationRecord
  validates :quantity, presence: true
  validates :product, presence: true
  validates :inventory, presence: true

  belongs_to :product
  belongs_to :inventory
end
