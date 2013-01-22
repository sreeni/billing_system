require 'spec_helper'

module Discount
  describe Price do
    context 'when price is lower than $100' do
      let(:cart){stub(:cart, :total_price => 70)}
      it 'should not apply any discount' do
        Price.calculate(cart).should eql 0
      end
    end

    context 'when price is higher than $100' do
      let(:cart){stub(:cart, :total_price => 330)}
      it 'should apply $5 discount on every $100' do
        Price.calculate(cart).should eql 15
      end
    end
  end
end
