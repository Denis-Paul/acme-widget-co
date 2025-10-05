#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/basket'
require_relative '../lib/product'
require_relative '../lib/delivery_rules/free_over_threshold'
require_relative '../lib/offers/bulk_discount'

# Setup catalogue
CATALOGUE = {
  'R01' => Product.new('Red Widget', 'R01', 3295),
  'G01' => Product.new('Green Widget', 'G01', 2495),
  'B01' => Product.new('Blue Widget', 'B01', 795)
}.freeze

puts "=" * 60
puts "Extended Examples - Alternative Rules & Offers"
puts "=" * 60
puts

# Example 1: Free Over Threshold Delivery Rule
puts "Example 1: FreeOverThreshold Delivery Rule"
puts "-" * 60
puts "Rule: Free delivery on orders $75+ (7500 cents), otherwise $6.95"
puts

delivery_rule = DeliveryRules::FreeOverThreshold.new(
  threshold_cents: 7500,      # $75.00
  standard_cost_cents: 695    # $6.95
)

# Test 1: Order under $75
basket1 = Basket.new(CATALOGUE, delivery_rule, [])
basket1.add('B01')  # $7.95
basket1.add('G01')  # $24.95
puts "Testing: B01, G01 (Subtotal: $32.90)"
puts "  Result: $#{format('%.2f', basket1.total)}"
puts "  Expected: $39.85 (subtotal + $6.95 delivery)"
puts

# Test 2: Order over $75
basket2 = Basket.new(CATALOGUE, delivery_rule, [])
basket2.add('R01')  # $32.95
basket2.add('R01')  # $32.95
basket2.add('G01')  # $24.95
puts "Testing: R01, R01, G01 (Subtotal: $90.85)"
puts "  Result: $#{format('%.2f', basket2.total)}"
puts "  Expected: $90.85 (subtotal, free delivery!)"
puts

# Example 2: Bulk Discount Offer
puts "\n" + "=" * 60
puts "Example 2: BulkDiscount Offer"
puts "-" * 60
puts "Offer: Buy 3+ Green Widgets (G01), save $2.00 per item"
puts

# Using the same delivery rule from above
offer = Offers::BulkDiscount.new(
  product_code: 'G01',
  min_quantity: 3,
  discount_per_item_cents: 200  # $2.00 off each
)

# Test 3: Buy only 2 (no discount)
basket3 = Basket.new(CATALOGUE, delivery_rule, [offer])
basket3.add('G01')
basket3.add('G01')
puts "Testing: G01, G01 (only 2 items - no bulk discount)"
puts "  Subtotal: $49.90"
puts "  Discount: $0.00 (need 3+ for bulk discount)"
puts "  Delivery: $6.95 (under $75)"
puts "  Result: $#{format('%.2f', basket3.total)}"
puts "  Expected: $56.85"
puts

# Test 4: Buy 3 (bulk discount applies!)
basket4 = Basket.new(CATALOGUE, delivery_rule, [offer])
basket4.add('G01')
basket4.add('G01')
basket4.add('G01')
puts "Testing: G01, G01, G01 (3 items - bulk discount applies!)"
puts "  Subtotal: $74.85"
puts "  Discount: $6.00 ($2 off × 3 items)"
puts "  After discount: $68.85"
puts "  Delivery: $6.95 (under $75 threshold)"
puts "  Result: $#{format('%.2f', basket4.total)}"
puts "  Expected: $75.80"
puts

# Test 5: Buy 4 (more savings!)
basket5 = Basket.new(CATALOGUE, delivery_rule, [offer])
basket5.add('G01')
basket5.add('G01')
basket5.add('G01')
basket5.add('G01')
puts "Testing: G01 × 4 (bulk discount + almost free delivery)"
puts "  Subtotal: $99.80"
puts "  Discount: $8.00 ($2 off × 4 items)"
puts "  After discount: $91.80"
puts "  Delivery: $0.00 (over $75 after discount!)"
puts "  Result: $#{format('%.2f', basket5.total)}"
puts "  Expected: $91.80"
puts

puts "=" * 60
puts "All extended examples completed!"
puts "=" * 60
