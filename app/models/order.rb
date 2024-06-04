# frozen_string_literal: true

class Order < ApplicationRecord
  validates :status, presence: true, inclusion: { in: %w[pending confirmed] }

  has_many :order_items
end
