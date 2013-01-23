require 'spec_helper'

shared_examples "discount is not applicable" do
  it 'should not be eligible for discount' do
    discount.applicable?(cart).should be_false
  end
end

shared_examples "discount is applicable" do
  it 'should be eligible for discount' do
    discount.applicable?(cart).should be_true
  end
end

module Discount
  describe Discount do
    let(:item_price){50}
    let(:items) do
      [FactoryGirl.build(:item, :price => item_price)]
    end

    let(:user){FactoryGirl.build(:customer)}

    let(:cart)do
      FactoryGirl.build(:cart, :user => user, :items => items)
    end

    describe Price do
      let(:discount){Price}

      context 'when price is lower than $100' do
        let(:item_price){70}
        it_should_behave_like 'discount is not applicable'
      end

      context 'when price is higher than $100' do
        let(:item_price){330}
        it_should_behave_like 'discount is applicable'

        it 'should apply $5 discount on every $100' do
          Price.calculate(cart).should eql 15
        end
      end
    end

    describe PercentageDiscount do
      module TestDiscount
        extend PercentageDiscount
        set_discount 0.10
      end


      context 'when cart contains grocery items' do
        let(:items) do
          [
            FactoryGirl.build(:item, :price => 50),
            FactoryGirl.build(:grocery_item, :price => 100)
          ]
        end

        it 'should not apply discount for grocery items' do
          TestDiscount.calculate(cart).should eql 5.0
        end
      end

      describe Employee do
        let(:discount){Employee}

        context 'when user is employee' do
          let(:user){FactoryGirl.build(:employee)}

          it_should_behave_like 'discount is applicable'
        end

        context 'when user is non employee' do
          let(:user){FactoryGirl.build(:customer)}

          it_should_behave_like 'discount is not applicable'
        end

      end

      describe Affiliate do
        let(:discount){Affiliate}

        context 'when user is an affiliate' do
          let(:user){FactoryGirl.build(:affiliate)}

          it_should_behave_like 'discount is applicable'

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

          it_should_behave_like 'discount is applicable'
        end

        context 'when user is new customer' do
          let(:user){FactoryGirl.build(:customer)}

          it_should_behave_like 'discount is not applicable'
        end
      end
    end
  end
end
