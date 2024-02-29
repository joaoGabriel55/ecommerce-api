# frozen_string_literal: true

FactoryBot.define do
  factory(:inventory) do
    quantity { Faker::Number.between(from: 1, to: 100) }
    supplier { Faker::Company.name }
  end
end
