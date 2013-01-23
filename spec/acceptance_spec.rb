require 'spec_helper'

describe 'Billing System' do
  describe 'calculate payable amount' do
    let(:customer){FactoryGirl.build(:customer)}

    context 'price based discounts ' do
      context 'when purchase price is less than $100' do
        let(:cart)do
          FactoryGirl.build(:cart, :user => customer).tap do |cart|
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
          FactoryGirl.build(:cart, :user => customer).tap do |cart|
            cart.add_item FactoryGirl.build(:item, :price => 100)
            cart.add_item FactoryGirl.build(:item, :price => 120)
          end
        end

        it 'should apply discount of $5 for every $100' do
          Billing.calculate(cart).should eql 210
        end
      end
    end

    context 'percentage based discounts' do
      let(:cart) do
        FactoryGirl.build(:cart, :user => user).tap do |cart|
          cart.add_item FactoryGirl.build(:item, :price => 50)
          cart.add_item FactoryGirl.build(:item, :price => 10)
        end
      end

      context 'user is employee' do
        let(:user){FactoryGirl.build(:employee)}
        it 'should apply 30% discount for an employee' do
          Billing.calculate(cart).should eql 42.0
        end
      end

      context 'user is affiliate' do
        let(:user){FactoryGirl.build(:affiliate)}
        it 'should apply 10% discount for an affiliate' do
          Billing.calculate(cart).should eql 54.0
        end
      end

      context 'user is customer' do
        let(:user){FactoryGirl.build(:old_customer)}
        it 'should apply 5% discount when customer is older than 2 years' do
          Billing.calculate(cart).should eql 57.0
        end
      end

      context 'cart contains grocery items' do
        let(:user){FactoryGirl.build(:employee)}
        let(:cart) do
          FactoryGirl.build(:cart, :user => user).tap do |cart|
            cart.add_item FactoryGirl.build(:grocery_item, :price => 50)
            cart.add_item FactoryGirl.build(:item, :price => 10)
          end
        end

        it 'should apply discount only on non-grocery items' do
          Billing.calculate(cart).should eql 57.0
        end
      end

      context 'when multiple discounts are possible' do
        context 'when user is employee and an old customer' do
          let(:user){FactoryGirl.build(:employee)}
          let(:cart) do
            FactoryGirl.build(:cart, :user => user).tap do |cart|
              cart.add_item FactoryGirl.build(:item, :price => 100)
            end
          end

          it 'should only apply a single percentage discount' do
            user.stub(:affiliate? => true)
            Billing.calculate(cart).should eql 65.0
          end
        end
      end
    end
  end
end
