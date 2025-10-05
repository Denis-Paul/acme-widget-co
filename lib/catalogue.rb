# frozen_string_literal: true

require_relative 'product'

# Manages the product catalogue
# Provides lookup functionality for products by code
class Catalogue
  def initialize(products)
    @products = products.each_with_object({}) do |product, hash|
      hash[product.code] = product
    end
  end

  def find(product_code)
    @products[product_code] || raise(ArgumentError, "Product not found: #{product_code}")
  end

  def all
    @products.values
  end
end
