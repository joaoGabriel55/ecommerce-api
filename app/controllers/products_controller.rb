# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :set_product, only: %i[show update destroy inventories]

  # GET /products
  def index
    @products = Product.all

    render json: @products
  end

  # GET /products/1
  def show
    render json: @product
  end

  # POST /products
  def create
    @product = Product.new(product_params)

    if @product.save
      render json: @product, status: :created, location: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1
  def update
    update_product(product_params)
  end

  # PATCH/PUT /products/1/inventories
  def inventories
    inventories = inventories_params[:inventories].map do |inventory|
      Inventory.new(supplier: inventory[:supplier], quantity: inventory[:quantity], products: [@product])
    end

    invalid_inventory = inventories.find { |inventory| !inventory.valid? }

    if invalid_inventory.present?
      render json: invalid_inventory.errors, status: :unprocessable_entity
    else
      update_product(inventories:)
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy!
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
  end

  def update_product(params)
    if @product.update(params)
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def product_params
    params.require(:product).permit(:name, :price)
  end

  def inventories_params
    params.require(:product).permit(inventories: %i[supplier quantity])
  end
end
