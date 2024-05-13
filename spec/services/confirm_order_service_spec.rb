# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ConfirmOrderService do
  describe '#call' do
    context 'when order does not exist' do
      it 'throws an exception' do
        expect { ConfirmOrderService.new(order: nil).call }.to raise_error(ConfirmOrderService::OrderNotFoundError)
      end
    end

    context 'when order exists' do
      let!(:product) { create(:product) }
      let!(:inventory) { create(:inventory, products: [product], quantity: 10) }
      let!(:order_item) { create(:order_item, product:, inventory:, quantity: 2) }
      let(:order) { create(:order, status: 'pending', order_items: [order_item]) }

      it 'updates the order status' do
        expect do
          ConfirmOrderService.new(order:).call
        end.to change { order.reload.status }.from('pending').to('confirmed')
      end

      it 'updates inventory quantities' do
        order = create(:order, status: 'pending')

        order.order_items.each do |order_item|
          inventory = Inventory.find(order_item.inventory_id)

          expect do
            ConfirmOrderService.new(order:).call
          end.to change { inventory.reload.quantity }.from(
            inventory.quantity
          ).to(inventory.quantity - order_item.quantity)
        end
      end
    end
  end
end
