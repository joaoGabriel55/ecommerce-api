Rails.application.routes.draw do
  resources :orders
  resources :products
  resources :inventories

  get "up" => "rails/health#show", as: :rails_health_check
end
