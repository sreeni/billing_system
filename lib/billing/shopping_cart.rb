class ShoppingCart
  attr_accessor :user

  def initialize
    @user = User.new
  end

  def add_item(item)
    @items ||=[]
    @items << item
  end

  def calculate(discounts)
    total_price - discounts.inject(0) do |total , discount|
      discount.calculate(self) + total
    end
  end

  def total_price
   @items.map(&:price).inject(0) do |total, price|
     total + price
   end
  end
end
