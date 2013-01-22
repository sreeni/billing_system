require 'spec_helper'

describe Billing do
  describe 'calculate payable amount' do
    context 'price based discounts ' do
      context 'when purchase price is less than $100' do
        let(:cart)do
          FactoryGirl.build(:cart).tap do |cart|
            cart.add_item FactoryGirl.build(:item, :price => 30)
            cart.add_item FactoryGirl.build(:item, :price => 20)
          end
        end

        it 'should not apply any discount' do
          Billing.calculate(cart).should eql 50
        end
      end

      context 'price exceeds $100' do
        let(:cart)do
          FactoryGirl.build(:cart).tap do |cart|
            cart.add_item FactoryGirl.build(:item, :price => 100)
            cart.add_item FactoryGirl.build(:item, :price => 120)
          end
        end

        it 'should apply discount of $5 for every $100' do
          Billing.calculate(cart).should eql 210
        end
      end
    end
  end
end
