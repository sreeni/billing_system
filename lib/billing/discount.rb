module Discount
  def self.all
    [Price, Employee, Affiliate, OldCustomer]
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

  module PercentageDiscount
    def calculate(cart)
      apply?(cart) ?  cart.total_price * @discount : 0
    end

    module ClassMethods
      def discount(val)
        @discount = val
      end
    end

    def self.extended(base)
      base.extend ClassMethods
    end
  end

  module Employee
    extend PercentageDiscount
    discount 0.3

    def self.apply?(cart)
      cart.user.employee?
    end
  end

  module Affiliate
    extend PercentageDiscount
    discount 0.1

    def self.apply?(cart)
      cart.user.affiliate?
    end
  end

  module OldCustomer
    extend PercentageDiscount
    discount 0.05
    YEAR_THRESHOLD = 2

    def self.apply?(cart)
      today = Date.today
      date_2_years_ago = Date.new(today.year - YEAR_THRESHOLD, today.month, today.day)
      cart.user.start_date <= date_2_years_ago
    end
  end
end
