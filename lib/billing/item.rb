class Item
  attr_accessor :price
  attr_accessor :grocery

  def initialize
    @grocery = false
  end

  def grocery?
    @grocery
  end
end
