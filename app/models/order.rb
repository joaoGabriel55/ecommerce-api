# frozen_string_literal: true

class Order < ApplicationRecord
  validates :status, presence: true, inclusion: { in: %w[pending confirmed] }

  has_and_belongs_to_many :order_items
end
