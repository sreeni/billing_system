require 'spec_helper'

describe ShoppingCart do
  let(:discount){ stub(:discount, :calculate => 0) }
  before(:each) do
    subject.add_item FactoryGirl.build(:item, :price => 30)
    subject.add_item FactoryGirl.build(:item, :price => 20)
  end

  it 'should calculate total amount payable' do
    subject.calculate([]).should eql 50
  end

  it 'should deduct discount when applicable' do
    discount.should_receive(:applicable?).with(subject).and_return(true)
    discount.should_receive(:calculate).with(subject)
    subject.calculate([discount])
  end

  it 'should not deduct discount when not applicable' do
    discount.should_receive(:applicable?).with(subject).and_return(false)
    discount.should_not_receive(:calculate)

    subject.calculate([discount])
  end

  it 'should deduct any applicable discounts from total payable' do
    discount.stub(:applicable? => true)
    discount.should_receive(:calculate).with(subject).and_return(30)

    subject.calculate([discount]).should eql 20
  end
end
