# frozen_string_literal: true

class Order < ApplicationRecord
  validates :products, presence: true

  has_and_belongs_to_many :products
end
