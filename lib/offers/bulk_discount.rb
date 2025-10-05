# frozen_string_literal: true

require_relative 'base'

module Offers
  # Bulk discount offer - buy 3 or more of the same item, get a discount per item
  # Example: Green Widgets normally $24.95, buy 3+ for $22.95 each (save $2.00 per item)
  class BulkDiscount < Base
    # @param product_code [String] The product code this offer applies to
    # @param min_quantity [Integer] Minimum quantity required to trigger the discount
    # @param discount_per_item_cents [Integer] Discount amount per item in cents
    def initialize(product_code:, min_quantity:, discount_per_item_cents:)
      @product_code = product_code
      @min_quantity = min_quantity
      @discount_per_item_cents = discount_per_item_cents
    end

    # This method fulfills the contract from the Offers::Base class
    # Returns discount amount in cents
    # @param items [Array<Product>] All items in the basket
    # @return [Integer] Total discount in cents
    def apply(items)
      matching_items = items.select { |item| item.code == @product_code }
      quantity = matching_items.count

      return 0 if quantity < @min_quantity

      # Apply discount to all items when minimum quantity is met
      total_discount_cents = quantity * @discount_per_item_cents
      total_discount_cents
    end
  end
end
