require 'date'

FactoryGirl.define do
  factory :cart, class: ShoppingCart do
  end

  factory :item, class: Item do
  end

  factory :employee, class: User do
    employee true
    affiliate false
  end

  factory :customer, class: User do
    employee false
    affiliate false
  end

  factory :old_customer, class: User do
    employee false
    affiliate false
    start_date Date.new(Date.today.year - 3, 1, 1)
  end

  factory :affiliate, class: User do
    employee false
    affiliate true
  end
end
