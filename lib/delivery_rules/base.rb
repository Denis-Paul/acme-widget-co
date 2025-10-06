# frozen_string_literal: true

module DeliveryRules
  # Base class for delivery rule strategies
  class Base
    # Calculate delivery cost based on subtotal
    def cost_for(subtotal_cents)
      raise NotImplementedError, "#{self.class} must implement #cost_for method"
    end
  end
end
