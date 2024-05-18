# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    let!(:product) { create(:product) }
    let!(:inventory) { create(:inventory, products: [product]) }
    let!(:inventory2) { create(:inventory, products: [product]) }
    let!(:order_item) { create(:order_item, product:, inventory: inventory2, quantity: 2) }
    let(:order) { create(:order, status: 'pending', order_items: [order_item]) }

    it 'returns a success response' do
      get :show, params: { id: order.to_param }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let!(:product) { create(:product) }
      let!(:inventory) { create(:inventory, products: [product]) }

      it 'creates a new product' do
        expect do
          post :create, params: { order: { products: [{ id: product.id, quantity: 1, inventory_id: inventory.id }] } }
        end.to change(Order, :count).by(1)
      end

      it 'returns a created response' do
        post :create, params: { order: { products: [{ id: product.id, quantity: 1, inventory_id: inventory.id }] } }

        expect(JSON.parse(response.body)['status']).to eq('pending')
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid params' do
      it 'returns an unprocessable_entity response' do
        post :create, params: { order: { products: [] } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:product) { create(:product) }
    let!(:product2) { create(:product, name: 'Product 2') }
    let!(:inventory) { create(:inventory, products: [product]) }
    let!(:inventory2) { create(:inventory, products: [product2]) }
    let!(:order_item) { create(:order_item, product:, inventory:, quantity: 2) }
    let(:order) { create(:order, status: 'pending', order_items: [order_item]) }

    context 'with valid params' do
      it 'updates the requested product' do
        patch :update,
              params: { id: order.to_param, products: [{ id: product2.id, quantity: 1, inventory_id: inventory2.id }] }
        order.reload
        expect(order.order_items.count).to eq(2)
      end

      it 'returns a success response' do
        patch :update,
              params: { id: order.to_param, products: [{ id: product2.id, quantity: 1, inventory_id: inventory2.id }] }
        expect(response).to be_successful
      end
    end

    context 'with invalid params' do
      it 'returns an unprocessable_entity response' do
        patch :update, params: { id: order.to_param, products: [] }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH #confirm' do
    let!(:product) { create(:product) }
    let!(:inventory) { create(:inventory, products: [product]) }
    let!(:order_item) { create(:order_item, product:, inventory:, quantity: 2) }
    let(:order) { create(:order, status: 'pending', order_items: [order_item]) }

    context 'with valid params' do
      it 'updates the requested product' do
        patch :confirm, params: { id: order.to_param }
        order.reload
        expect(order.status).to eq('confirmed')
      end

      it 'returns a success response' do
        patch :confirm, params: { id: order.to_param }
        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:product) { create(:product) }
    let!(:inventory) { create(:inventory, products: [product]) }
    let!(:order_item) { create(:order_item, product:, inventory:, quantity: 2) }
    let!(:order) { create(:order, status: 'pending', order_items: [order_item]) }

    it 'destroys the requested product' do
      expect do
        delete :destroy, params: { id: order.to_param }
      end.to change(Order, :count).by(-1)
    end
  end
end
