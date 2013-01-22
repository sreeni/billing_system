require 'spec_helper'

describe Billing do
  describe 'calculate payable amount' do
    context 'no discounts' do
      let(:cart)do
        FactoryGirl.build(:cart).tap do |cart|
          cart.add_item FactoryGirl.build(:item, :price => 30)
          cart.add_item FactoryGirl.build(:item, :price => 20)
        end
      end

      it 'should calculate total payable' do
        pending
        Billing.calculate(cart).should eql 50
      end
    end
  end
end
