class ShoppingCart
  def add_item(item)
    @items ||=[]
    @items << item
  end

  def calculate
   @items.map(&:price).inject(0) do |total, price|
     total + price
   end
  end
end
