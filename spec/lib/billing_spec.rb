require 'spec_helper'

describe Billing do
  let(:cart){FactoryGirl.build(:cart)}
  let(:discounts){[stub(:discount)]}

  it 'should calculate total payable amount from shopping cart' do
    cart.should_receive(:calculate).and_return 20
    Billing.calculate(cart).should eql 20
  end

  it 'should calculate total payable amount using discounts' do
    Discount.should_receive(:all).and_return(discounts)
    cart.should_receive(:calculate).with(discounts)

    Billing.calculate(cart)
  end
end
