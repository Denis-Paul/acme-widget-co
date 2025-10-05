# frozen_string_literal: true

require_relative 'base'

module DeliveryRules
  # Tiered delivery pricing based on order subtotal ranges
  # Accepts rules as array of hashes with :range and :cost
  # Ranges should cover all possible subtotal values
  class Tiered < Base
    # @param rules_config [Array<Hash>] Array of rules with :range and :cost keys
    #   Example: [{range: 0...5000, cost: 495}, {range: 5000...9000, cost: 295}]
    def initialize(rules_config)
      @rules = rules_config
    end

    # This method fulfills the contract from the base class
    # @param subtotal_cents [Integer] Order subtotal in cents
    # @return [Integer] Delivery cost in cents
    def cost_for(subtotal_cents)
      rule = @rules.find { |r| r[:range].cover?(subtotal_cents) }
      rule ? rule[:cost] : 0
    end
  end
end
