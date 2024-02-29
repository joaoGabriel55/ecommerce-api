# frozen_string_literal: true

class Inventory < ApplicationRecord
  validates :supplier, presence: true
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }

  has_and_belongs_to_many :products
end
