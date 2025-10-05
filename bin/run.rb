#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/basket'
require_relative '../lib/product'
require_relative '../lib/delivery_rules/tiered'
require_relative '../lib/offers/buy_one_get_one_half_price'

# Setup Acme Widget Co catalogue
# Prices are stored in cents to avoid floating-point errors
CATALOGUE = {
  'R01' => Product.new(code: 'R01', price_cents: 3295),  # Red Widget - $32.95
  'G01' => Product.new(code: 'G01', price_cents: 2495),  # Green Widget - $24.95
  'B01' => Product.new(code: 'B01', price_cents: 795)    # Blue Widget - $7.95
}.freeze

# Setup delivery rules (using cents throughout)
DELIVERY_RULES = DeliveryRules::Tiered.new([
  { range: 0...5000, cost: 495 },    # Under $50.00: $4.95 delivery
  { range: 5000...9000, cost: 295 },  # $50.00-$89.99: $2.95 delivery
  { range: 9000..Float::INFINITY, cost: 0 }  # $90.00+: Free delivery
])

# Setup offers
OFFERS = [
  Offers::BuyOneGetOneHalfPrice.new(product_code: 'R01')
]

# Helper method to create and run a basket example
def run_example(product_codes, expected)
  basket = Basket.new(CATALOGUE, DELIVERY_RULES, OFFERS)

  puts "Testing basket with: #{product_codes.join(', ')}"
  product_codes.each { |code| basket.add(code) }
  
  total = basket.total
  status = total == expected ? 'PASS' : 'FAIL'
  
  puts "  Result: $#{format('%.2f', total)}"
  puts "  Expected: $#{format('%.2f', expected)}"
  puts "  Status: [#{status}]"
  puts
end

puts "Acme Widget Co - Basket Examples"
puts "=" * 50
puts

run_example(['B01', 'G01'], 37.85)
run_example(['R01', 'R01'], 54.38)  # Cents: 5438
run_example(['R01', 'G01'], 60.85)
run_example(['B01', 'B01', 'R01', 'R01', 'R01'], 98.28)  # Cents: 9828

puts "=" * 50
puts "All test cases completed!"
