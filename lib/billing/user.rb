require 'date'

class User
  attr_accessor :employee
  attr_accessor :affiliate
  attr_accessor :start_date

  def initialize
    @start_date = Date.today
    @employee = false
    @affiliate = false
  end

  def employee?
    @employee
  end

  def affiliate?
    @affiliate
  end
end
