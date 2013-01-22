require 'spec_helper'

describe ShoppingCart do
  before(:each) do
    subject.add_item FactoryGirl.build(:item, :price => 30)
    subject.add_item FactoryGirl.build(:item, :price => 20)
  end
  it 'should calculate total amount payable' do
    subject.calculate.should eql 50
  end
end
