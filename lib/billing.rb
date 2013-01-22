require "billing/version"
require "billing/shopping_cart"
require "billing/item"

module Billing
  def self.calculate(cart)
    cart.calculate
  end
end
