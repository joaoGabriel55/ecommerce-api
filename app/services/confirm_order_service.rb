# frozen_string_literal: true

class ConfirmOrderService
  def initialize(order:)
    @order = order
  end

  attr_accessor :order

  def call
    order.status = 'confirmed'

    order.save
  end
end
