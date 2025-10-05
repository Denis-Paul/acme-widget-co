# frozen_string_literal: true

# Shopping basket with configurable delivery rules and offers
# Uses dependency injection for catalogue hash, delivery rules, and offers
class Basket
  def initialize(catalogue, delivery_rule, offers = [])
    @catalogue = catalogue
    @delivery_rule = delivery_rule
    @offers = offers
    @items = []
  end

  def add(product_code)
    product = @catalogue[product_code]
    @items << product if product
  end

  def total
    return 0.0 if @items.empty?

    subtotal_cents = calculate_subtotal_cents
    discount_cents = calculate_discounts_cents
    discounted_subtotal_cents = subtotal_cents - discount_cents
    
    # Delivery rule works with cents directly
    delivery_cents = @delivery_rule.cost_for(discounted_subtotal_cents)

    # Calculate total in cents, then convert to dollars
    total_cents = discounted_subtotal_cents + delivery_cents
    (total_cents / 100.0).round(2) # Cents to dollars
  end

  private

  def calculate_subtotal_cents
    @items.sum(&:price)
  end

  def calculate_discounts_cents
    @offers.sum { |offer| offer.apply(@items) }
  end
end
