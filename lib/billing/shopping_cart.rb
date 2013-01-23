class ShoppingCart
  attr_accessor :user
  attr_accessor :items

  def initialize
    @percentage_discount_applied = false
  end

  def add_item(item)
    @items ||=[]
    @items << item
  end

  def calculate(discounts)
    total_price - discounts.inject(0) do |total , discount|
      if (discount_applicable?(discount))
        total
      else
        percentage_discount_applied! if discount.type == :percentage
        total + discount.calculate(self)
      end
    end
  end

  def total_price
   @items.map(&:price).inject(0) do |total, price|
     total + price
   end
  end

  private

  def discount_applicable?(discount)
    already_applied?(discount.type) || !discount.applicable?(self)
  end

  def already_applied?(type)
    type == :percentage && @percentage_discount_applied
  end

  def percentage_discount_applied!
    @percentage_discount_applied = true
  end
end
