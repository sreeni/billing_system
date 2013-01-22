require "billing/version"
require "billing/shopping_cart"
require "billing/item"
require "billing/discount"
require "billing/user"

module Billing
  def self.calculate(cart)
    cart.calculate(Discount.all)
  end
end
