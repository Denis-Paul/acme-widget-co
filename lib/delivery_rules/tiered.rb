# frozen_string_literal: true

require_relative 'base'

module DeliveryRules
  # Tiered delivery pricing based on order subtotal ranges
  # Accepts rules as array of hashes with :range and :cost
  class Tiered < Base
    def initialize(rules_config)
      @rules = rules_config
    end

    def cost_for(subtotal_cents)
      rule = @rules.find { |r| r[:range].cover?(subtotal_cents) }
      rule ? rule[:cost] : 0
    end
  end
end
