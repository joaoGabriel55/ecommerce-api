FactoryBot.define do
  factory(:inventory) do
    quantity { Faker::Number.between(from: 1, to: 100) }
    supplier { Faker::Company.name }

    # after(:build) do |inventory, _evaluator|
    #   product = FactoryBot.build(:product)
    #   inventory.product = product
    # end
  end
end
