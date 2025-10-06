# frozen_string_literal: true

module Offers
  # Base class for offer strategies
  class Base
    def apply(items)
      raise NotImplementedError, "#{self.class} must implement #apply method"
    end
  end
end
