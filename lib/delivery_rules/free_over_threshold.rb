# frozen_string_literal: true

require_relative 'base'

module DeliveryRules
  # Free delivery when order exceeds a threshold amount
  # Below threshold, charges a fixed delivery cost
  class FreeOverThreshold < Base
    # @param threshold_cents [Integer] Minimum order amount for free delivery (in cents)
    # @param standard_cost_cents [Integer] Standard delivery cost when below threshold (in cents)
    def initialize(threshold_cents:, standard_cost_cents:)
      @threshold_cents = threshold_cents
      @standard_cost_cents = standard_cost_cents
    end

    # This method fulfills the contract from the base class
    # @param subtotal_cents [Integer] Order subtotal in cents
    # @return [Integer] Delivery cost in cents (0 if over threshold)
    def cost_for(subtotal_cents)
      subtotal_cents >= @threshold_cents ? 0 : @standard_cost_cents
    end
  end
end
