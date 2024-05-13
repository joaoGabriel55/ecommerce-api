# frozen_string_literal: true

puts 'Creating seeds...'

ActiveRecord::Base.logger = Logger.new(STDOUT)

product = Product.create(name: 'Product 1', price: 10)
inventory = Inventory.create(products: [product], quantity: 10, supplier: 'Supplier' + Random.rand(1000).to_s)
order_item = OrderItem.create(product:, inventory:, quantity: 2)

Order.create(status: 'pending', order_items: [order_item])

puts 'Done!'
