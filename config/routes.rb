# frozen_string_literal: true

Rails.application.routes.draw do
  resources :orders do
    member do
      patch 'confirm'
    end
  end
  resources :products do
    member do
      patch 'inventories'
    end
  end
  resources :inventories

  get 'up' => 'rails/health#show', as: :rails_health_check
end
