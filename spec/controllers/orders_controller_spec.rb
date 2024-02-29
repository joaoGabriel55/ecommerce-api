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
    let!(:inventory) { create(:inventory, products: [product]) }
    let(:order) { create(:order, products: [product]) }

    it 'returns a success response' do
      get :show, params: { id: order.to_param }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let!(:product) { create(:product) }
      let!(:inventory) { create(:inventory, products: [product]) }
      let!(:inventory) { create(:inventory, products: [product]) }

      it 'creates a new product' do
        expect do
          post :create, params: { order: { products: [{ id: product.id }] } }
        end.to change(Order, :count).by(1)
      end

      it 'returns a created response' do
        post :create, params: { order: { products: [{ id: product.id }] } }
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
    let!(:order) { create(:order, products: [product]) }

    context 'with valid params' do
      it 'updates the requested product' do
        patch :update, params: { id: order.to_param, products: [{ id: product2.id }] }
        order.reload
        expect(order.products.count).to eq(2)
      end

      it 'returns a success response' do
        patch :update, params: { id: order.to_param, products: [{ id: product2.id }] }
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

  describe 'DELETE #destroy' do
    let!(:product) { create(:product) }
    let!(:inventory) { create(:inventory, products: [product]) }
    let!(:order) { create(:order, products: [product]) }

    it 'destroys the requested product' do
      expect do
        delete :destroy, params: { id: order.to_param }
      end.to change(Order, :count).by(-1)
    end
  end
end
