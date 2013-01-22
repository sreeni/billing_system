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

    context 'user based discounts' do
      let(:cart) do
        FactoryGirl.build(:cart, :user => employee).tap do |cart|
          cart.add_item FactoryGirl.build(:item, :price => 50)
          cart.add_item FactoryGirl.build(:item, :price => 10)
        end
      end

      context 'user is employee' do
        let(:employee){FactoryGirl.build(:employee)}
        it 'should apply discount for an employee' do
          Billing.calculate(cart).should eql 42.0
        end
      end

      context 'user is affiliate' do
        let(:employee){FactoryGirl.build(:affiliate)}
        it 'should apply discount for an employee' do
          Billing.calculate(cart).should eql 54.0
        end
      end
    end
  end
end
