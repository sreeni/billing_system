module Discount
  def self.all
    [Price, Employee, Affiliate]
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

  module Employee
    def self.calculate(cart)
      cart.user.employee? ? cart.total_price * 0.3 : 0
    end
  end

  module Affiliate
    def self.calculate(cart)
      cart.user.affiliate? ? cart.total_price * 0.1 : 0
    end
  end
end
