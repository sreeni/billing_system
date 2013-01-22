require 'spec_helper'

shared_examples "discount is not applicable" do
  it 'should not apply any discount' do
    discount.calculate(cart).should eql 0
  end
end

module Discount
  describe Discount do
    let(:items) do
      [
        FactoryGirl.build(:item, :price => 100),
      ]
    end

    let(:cart)do
      FactoryGirl.build(:cart, :user => user, :items => items)
    end

    describe Price do
      let(:discount){Price}
      let(:user){FactoryGirl.build(:customer)}

      context 'when price is lower than $100' do
        let(:cart){stub(:cart, :total_price => 70)}

        it_should_behave_like 'discount is not applicable'
      end

      context 'when price is higher than $100' do
        let(:cart){stub(:cart, :total_price => 330)}

        it 'should apply $5 discount on every $100' do
          Price.calculate(cart).should eql 15
        end
      end
    end

    describe 'percentage discounts' do

      describe Employee do
        let(:discount){Employee}

        context 'when user is employee' do
          let(:user){FactoryGirl.build(:employee)}

          it 'should apply a discount' do
            Employee.calculate(cart).should eql 30.0
          end
        end

        context 'when user is non employee' do
          let(:user){FactoryGirl.build(:customer)}

          it_should_behave_like 'discount is not applicable'
        end

        context 'when cart contains grocery items' do
          let(:user){FactoryGirl.build(:employee)}

          let(:items) do
            [
              FactoryGirl.build(:item, :price => 10),
              FactoryGirl.build(:grocery_item, :price => 20)
            ]
          end

          let(:cart) do
            stub(:cart, :total_price => 30, :user => user, :items => items)
          end

          it 'should not apply discount for grocery items' do
            Employee.calculate(cart).should eql 3.0
          end
        end
      end

      describe Affiliate do
        let(:discount){Affiliate}
        context 'when user is an affiliate' do
          let(:user){FactoryGirl.build(:affiliate)}

          it 'should apply a discount' do
            Affiliate.calculate(cart).should eql 10.0
          end
        end

        context 'when user is non affiliate' do
          let(:user){FactoryGirl.build(:customer)}

          it_should_behave_like 'discount is not applicable'
        end
      end

      describe OldCustomer do
        let(:discount){OldCustomer}
        context 'when user is an old customer' do
          let(:user){FactoryGirl.build(:old_customer)}

          it 'should apply a discount' do
            OldCustomer.calculate(cart).should eql 5.0
          end
        end

        context 'when user is new customer' do
          let(:user){FactoryGirl.build(:customer)}

          it_should_behave_like 'discount is not applicable'
        end
      end
    end
  end
end
