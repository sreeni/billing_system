module Discount
  def self.all
    [Price]
  end

  module Price
    THRESHOLD = 100
    DISCOUNT = 5
    def self.calculate(cart)
      total_price = cart.total_price
      return 0 if total_price < THRESHOLD

      DISCOUNT * (total_price - total_price % THRESHOLD) / THRESHOLD
    end
  end
end
