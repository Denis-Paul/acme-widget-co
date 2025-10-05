# Acme Widget Co - Shopping Basket System

A Ruby implementation of a flexible shopping basket system with configurable delivery rules and promotional offers.

## Features

- **Simple Product Catalogue**: Hash-based product lookup by code
- **Flexible Delivery Rules**: Strategy pattern for extensible delivery cost calculation
- **Promotional Offers**: Strategy pattern for pluggable discount mechanisms
- **Dependency Injection**: All components are loosely coupled and testable
- **Cents-Based Calculations**: All monetary calculations use integers (cents) to avoid floating-point errors

## Design Principles

### Separation of Concerns
Each class has a single, well-defined responsibility:
- `Product`: Immutable value object for product data
- `Basket`: Shopping basket logic and total calculation
- `DeliveryRules::*`: Delivery cost calculation strategies
- `Offers::*`: Promotional discount strategies

### Strategy Pattern
Both delivery rules and offers use the strategy pattern, allowing new rules and offers to be added without modifying existing code:

```ruby
# Delivery rules implement a common interface
class DeliveryRules::Base
  def calculate(subtotal)
    # Implementation
  end
end

# Offers implement a common interface
class Offers::Base
  def apply(items)
    # Implementation
  end
end
```

### Dependency Injection
The `Basket` class accepts its dependencies through the constructor, making it easy to configure:

```ruby
basket = Basket.new(
  catalogue: catalogue,
  delivery_rule: delivery_rule,
  offers: offers
)
```

## Current Implementation

### Products
- **R01** - Red Widget: $32.95
- **G01** - Green Widget: $24.95
- **B01** - Blue Widget: $7.95

### Delivery Rules
- Orders under $50: $4.95 delivery
- Orders $50-$89.99: $2.95 delivery
- Orders $90+: Free delivery

### Offers
- Buy one red widget (R01), get the second half price

## Usage

### Running Examples
```bash
ruby bin/run.rb
```

### Programmatic Usage
```ruby
require_relative 'lib/basket'
require_relative 'lib/product'
require_relative 'lib/delivery_rules/tiered'
require_relative 'lib/offers/buy_one_get_one_half_price'

# Setup catalogue - prices are in cents to avoid floating-point errors
catalogue = {
  'R01' => Product.new('Red Widget', 'R01', 3295),
  'G01' => Product.new('Green Widget', 'G01', 2495),
  'B01' => Product.new('Blue Widget', 'B01', 795)
}.freeze

delivery_rule = DeliveryRules::Tiered.new([
  { range: 0...5000, cost: 495 },    # Under $50.00: $4.95 delivery
  { range: 5000...9000, cost: 295 },  # $50.00-$89.99: $2.95 delivery
  { range: 9000..Float::INFINITY, cost: 0 }  # $90.00+: Free delivery
])

offers = [
  Offers::BuyOneGetOneHalfPrice.new(product_code: 'R01')
]

# Create basket and add items
basket = Basket.new(catalogue, delivery_rule, offers)

basket.add('B01')
basket.add('G01')

puts basket.total # => 37.85
```

## Extending the System

### Adding a New Delivery Rule
```ruby
class DeliveryRules::FlatRate < DeliveryRules::Base
  def initialize(cost_cents)
    @cost_cents = cost_cents
  end

  # @param subtotal_cents [Integer] Order subtotal in cents
  # @return [Integer] Delivery cost in cents
  def cost_for(subtotal_cents)
    @cost_cents  # Always the same cost
  end
end

# Usage
delivery_rule = DeliveryRules::FlatRate.new(500)  # Always $5.00
```

### Adding a New Offer
```ruby
class Offers::BuyTwoGetOneFree < Offers::Base
  def initialize(product_code:)
    @product_code = product_code
  end

  def apply(items)
    matching = items.select { |i| i.code == @product_code }
    free_items = matching.size / 3
    matching.first.price * free_items  # Returns discount in cents
  end
end
```