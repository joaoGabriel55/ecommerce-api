# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :set_order, only: %i[show update destroy confirm]

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

    @order = Order.new(order_items: order_items(order_params[:products]), status: 'pending')

    if @order.save
      render json: @order, status: :created, location: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /orders/1
  def update
    new_products = valid_products(params[:products])

    return render json: { message: 'Products not found' }, status: :unprocessable_entity if new_products.empty?

    updated_products = @order.order_items + order_items(new_products)

    if @order.update(order_items: updated_products)
      render json: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /orders/1/confirm
  def confirm
    ConfirmOrderService.new(order: @order).call

    render json: { message: 'Order confirmed' }
  rescue StandardError
    render json: { message: 'Order not confirmed' }, status: :unprocessable_entity
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

  def valid_products(products_param)
    return [] if products_param.nil? || products_param.empty?

    products = load_products(products_param)

    return [] if products.empty?

    products_param.map do |product|
      { id: product[:id], inventory_id: product[:inventory_id], quantity: product[:quantity] }
    end
  end

  def load_products(products_param)
    products_ids = products_param.map { |product| product[:id] }
    inventories_ids = products_param.map { |product| product[:inventory_id] }

    products = Product.where(id: products_ids).joins(:inventories).where(inventories: { id: inventories_ids })

    return [] if products.count != products_param.count

    products
  end

  def order_items(products)
    products.map do |product|
      OrderItem.new(
        product_id: product[:id],
        inventory_id: product[:inventory_id],
        quantity: product[:quantity]
      )
    end
  end

  # Only allow a list of trusted parameters through.
  def order_params
    params.require(:order).permit(products: %i[id quantity inventory_id])
  end
end
