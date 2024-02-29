# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :set_order, only: %i[show update destroy]

  # GET /orders
  def index
    @orders = Order.all

    render json: @orders
  end

  # GET /orders/1
  def show
    render json: @order
  end

  # POST /orders
  def create
    return render json: { message: 'Products not found' }, status: :unprocessable_entity if params[:order].nil?

    @order = Order.new(products: load_products(order_params[:products]))

    if @order.save
      render json: @order, status: :created, location: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /orders/1
  def update
    new_products = load_products(params[:products])

    return render json: { message: 'Products not found' }, status: :unprocessable_entity if new_products.empty?

    updated_products = @order.products + new_products

    if @order.update(products: updated_products)
      render json: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # DELETE /orders/1
  def destroy
    @order.destroy!
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end

  def load_products(products_param)
    return [] if products_param.nil? || products_param.empty?

    products_ids = products_param.map { |product| product[:id] }
    Product.where(id: products_ids)
  end

  # Only allow a list of trusted parameters through.
  def order_params
    params.require(:order).permit(products: %i[id])
  end
end
