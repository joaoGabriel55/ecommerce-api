require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    let(:product) { create(:product) }

    it 'returns a success response' do
      get :show, params: { id: product.to_param }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new product' do
        expect {
          post :create, params: { product: { name: 'Test Product', price: 10 } }
        }.to change(Product, :count).by(1)
      end

      it 'returns a created response' do
        post :create, params: { product: { name: 'Test Product', price: 10 } }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid params' do
      it 'returns an unprocessable_entity response' do
        post :create, params: { product: { name: nil, price: 10 } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:product) { create(:product) }

    context 'with valid params' do
      it 'updates the requested product' do
        patch :update, params: { id: product.to_param, product: { name: 'New Name' } }
        product.reload
        expect(product.name).to eq('New Name')
      end

      it 'returns a success response' do
        patch :update, params: { id: product.to_param, product: { name: 'New Name' } }
        expect(response).to be_successful
      end
    end

    context 'with invalid params' do
      it 'returns an unprocessable_entity response' do
        patch :update, params: { id: product.to_param, product: { name: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'patch #inventories' do
    let!(:product) { create(:product) }

    context 'with valid params' do
      it 'updates the requested product' do
        patch :inventories, params: {
          id: product.to_param,
          product: {
            inventories: [{ supplier: 'New Supplier', quantity: 10 }]
          } }
        product.reload

        expect(product.inventories.first.supplier).to eq('New Supplier')
      end

      it 'returns a success response' do
        patch :inventories, params: {
          id: product.to_param,
          product: {
            inventories: [{ supplier: 'New Supplier', quantity: 10 }]
          } }
        expect(response).to be_successful
      end
    end

    context 'with invalid params' do
      it 'returns an unprocessable_entity response' do
        patch :inventories, params: {
          id: product.to_param,
          product: {
            inventories: [{ supplier: nil, quantity: 10 }]
          } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:product) { create(:product) }

    it 'destroys the requested product' do
      expect {
        delete :destroy, params: { id: product.to_param }
      }.to change(Product, :count).by(-1)
    end
  end
end
