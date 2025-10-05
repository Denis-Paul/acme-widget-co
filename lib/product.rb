# frozen_string_literal: true

# Represents a product in the catalogue
# Immutable value object containing product code and price in cents
class Product
  attr_reader :code, :price_cents

  # @param code [String] Product code
  # @param price_cents [Integer] Price in cents (e.g., 3295 for $32.95)
  def initialize(code:, price_cents:)
    @code = code
    @price_cents = price_cents
  end

  # Returns price in dollars as a float for display purposes
  def price
    @price_cents / 100.0
  end

  def ==(other)
    other.is_a?(Product) && code == other.code && price_cents == other.price_cents
  end

  alias eql? ==

  def hash
    [code, price_cents].hash
  end
end
