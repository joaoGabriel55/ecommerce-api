FactoryBot.define do
  factory(:product) do
    name { Faker::Commerce.product_name }
    price { Faker::Commerce.price(range: 1..100.0) * 100 }

    # after(:build) do |product, _evaluator|
    #   inventories = [
    #     FactoryBot.build(:inventory),
    #     FactoryBot.build(:inventory)
    #   ]

    #   product.inventories = inventories
    # end
  end
end
