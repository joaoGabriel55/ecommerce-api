# frozen_string_literal: true

class ConfirmOrderService
  class OrderNotFoundError < StandardError
    def initialize
      super('Order not found')
    end
  end

  def initialize(order:)
    @order = order
    @order_items = order&.order_items
  end

  attr_accessor :order, :order_items

  def call
    ActiveRecord::Base.transaction do
      ensure_order_exists_and_pending

      update_inventories_quantity

      confirm_order
    end
  rescue ActiveRecord::RecordNotFound
    raise OrderNotFoundError
  end

  private

  def ensure_order_exists_and_pending
    raise ActiveRecord::RecordNotFound unless Order.exists?(id: order&.id, status: 'pending')
  end

  def update_inventories_quantity
    items_quantities_map = order_items.map { |item| [item.inventory.id, item.quantity] }.to_h
    inventories_ids = order_items.pluck(:inventory_id)
    inventories = Inventory.where(id: inventories_ids)

    inventories.each do |inventory|
      inventory.quantity -= items_quantities_map[inventory.id]
    end

    upsert_inventories(inventories)
  end

  def upsert_inventories(inventories)
    Inventory.upsert_all(
      inventories.map { |inventory| { id: inventory.id, quantity: inventory.quantity, supplier: inventory.supplier } },
      unique_by: :id
    )
  end

  def confirm_order
    order.status = 'confirmed'
    order.save!
  end
end
