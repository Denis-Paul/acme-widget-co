# frozen_string_literal: true

require_relative 'base'

module Offers
  # Buy one get one half price offer for a specific product
  # Takes a product code and applies 50% discount to every second item
  class BuyOneGetOneHalfPrice < Base
    def initialize(product_code:)
      @product_code = product_code
    end

    # This method fulfills the contract from the Offers::Base class
    # Returns discount amount in cents
    # @param items [Array<Product>] All items in the basket
    # @return [Integer] Total discount in cents
    def apply(items)
      matching_items = items.select { |item| item.code == @product_code }
      return 0 if matching_items.empty?

      # Calculate discount for every second item (integer division, no rounding needed)
      num_of_pairs = matching_items.count / 2
      discount_per_item_cents = matching_items.first.price_cents / 2
      discount_amount_cents = discount_per_item_cents * num_of_pairs

      discount_amount_cents
    end
  end
end
