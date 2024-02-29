# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InventoriesController, type: :controller do
  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    let!(:product) { create(:product) }
    let(:inventory) { create(:inventory, product:) }

    it 'returns a success response' do
      get :show, params: { id: inventory.to_param }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    let!(:product) { create(:product) }

    context 'with valid params' do
      it 'creates a new inventory' do
        expect do
          post :create, params: { inventory: { supplier: 'Supplier Nice', quantity: 10, product_id: product.id } }
        end.to change(Inventory, :count).by(1)
      end

      it 'returns a created response' do
        post :create, params: { inventory: { supplier: 'Supplier Nice', quantity: 10, product_id: product.id } }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid params' do
      it 'returns an unprocessable_entity response' do
        post :create, params: { inventory: { supplier: nil, quantity: 10 } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:product) { create(:product) }
    let(:inventory) { create(:inventory, product:) }

    context 'with valid params' do
      it 'updates the requested inventory' do
        patch :update, params: { id: inventory.to_param, inventory: { supplier: 'New Supplier' } }
        inventory.reload
        expect(inventory.supplier).to eq('New Supplier')
      end

      it 'returns a success response' do
        patch :update, params: { id: inventory.to_param, inventory: { supplier: 'New Supplier' } }
        expect(response).to be_successful
      end
    end

    context 'with invalid params' do
      it 'returns an unprocessable_entity response' do
        patch :update, params: { id: inventory.to_param, inventory: { supplier: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:inventory) { create(:inventory, product: create(:product)) }

    it 'destroys the requested inventory' do
      expect do
        delete :destroy, params: { id: inventory.to_param }
      end.to change(Inventory, :count).by(-1)
    end
  end
end
