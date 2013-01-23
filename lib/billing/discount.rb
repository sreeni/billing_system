module Discount
  def self.all
    [Price, Employee, Affiliate, OldCustomer]
  end

  module Price
    THRESHOLD = 100
    DISCOUNT = 5
    def self.calculate(cart)
      total_price = cart.total_price
      DISCOUNT * (total_price - total_price % THRESHOLD) / THRESHOLD
    end

    def self.applicable?(cart)
      cart.total_price > THRESHOLD
    end
  end

  module PercentageDiscount
    def calculate(cart)
      p self
      non_grocery_items = cart.items.reject do |item|
        item.grocery?
      end

      non_grocery_items.map(&:price).inject(0) do |total, price|
        total + @discount * price
      end
    end

    module ClassMethods
      def set_discount(val)
        @discount = val
      end
    end

    def self.extended(base)
      base.extend ClassMethods
    end
  end

  module Employee
    extend PercentageDiscount
    set_discount 0.3

    def self.applicable?(cart)
      cart.user.employee?
    end
  end

  module Affiliate
    extend PercentageDiscount
    set_discount 0.1

    def self.applicable?(cart)
      cart.user.affiliate?
    end
  end

  module OldCustomer
    extend PercentageDiscount
    set_discount 0.05
    YEAR_THRESHOLD = 2

    def self.applicable?(cart)
      today = Date.today
      date_2_years_ago = Date.new(today.year - YEAR_THRESHOLD, today.month, today.day)
      cart.user.start_date <= date_2_years_ago
    end
  end
end
