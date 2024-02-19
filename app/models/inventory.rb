class Inventory < ApplicationRecord
  validates :supplier, presence: true
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }

  belongs_to :product
end
