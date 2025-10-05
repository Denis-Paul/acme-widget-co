# frozen_string_literal: true

module DeliveryRules
  # Base class for delivery rule strategies
  # Defines the interface that all delivery rules must implement
  class Base
    # Calculate delivery cost based on subtotal in cents
    # @param subtotal_cents [Integer] Order subtotal in cents
    # @return [Integer] Delivery cost in cents
    def cost_for(subtotal_cents)
      raise NotImplementedError, "#{self.class} must implement #cost_for method"
    end
  end
end
