# frozen_string_literal: true

# Represents a product in the catalogue
class Product
  attr_reader :name, :code, :price

  def initialize(name, code, price_in_cents)
    @name = name
    @code = code
    @price = price_in_cents
  end
end
