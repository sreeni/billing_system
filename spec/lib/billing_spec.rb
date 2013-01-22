require 'spec_helper'

describe Billing do
  let(:cart){FactoryGirl.build(:cart)}

  it 'should calculate total payable amount from shopping cart' do
    cart.should_receive(:calculate).and_return 20
    Billing.calculate(cart).should eql 20
  end

  it 'should calculate total payable amount using discounts'

end
