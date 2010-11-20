require File.dirname(__FILE__) + '/test_helper'

describe RVista::POLineItem do

  before(:each) do
    @row = []
    @row << "D"
    @row << "1"
    @row << "IB"
    @row << "0701180358"
    @row << "DIGGING TO AMERICA"
    @row << "3"
    @row << "0.00"
    @row << "EA"
    @row << nil
    @row << nil
    @row << "43"
    @row << "Y"
    @row << nil
    @row << nil

    @row2 = []
    @row2 << "D"
    @row2 << "1"
    @row2 << "IB"
    @row2 << "0701180358"
    @row2 << "DIGGING TO AMERICA"
    @row2 << "3"
    @row2 << "0.00"
    @row2 << "EA"
    @row2 << nil
    @row2 << nil
    @row2 << "43"
    @row2 << "N"
    @row2 << nil
    @row2 << nil
  end

  it "should correctly initialize from an array" do
    item = RVista::POLineItem.load_from_array(@row)
    item.should be_a(RVista::POLineItem)

    item.line_num.should == 1
    item.qualifier.should == "IB"
    item.ean.should == "0701180358"
    item.description.should == "DIGGING TO AMERICA"
    item.qty.should == 3
    item.nett_unit_price.should == 0.00
    item.unit_measure.should == "EA"
    item.retail_unit_price.should == nil
    item.was_unit_price.should == nil
    item.discount.should == 43
    item.backorder.should == true
    item.additional_discount.should == nil
    item.firm_sale.should == nil
  end

  it "should throw appropriate exceptions when loading from an array" do
    lambda {
      item = RVista::POLineItem.load_from_array(%w[D blah])
    }.should raise_error(RVista::InvalidLineItemError)
  end

  it "should correctly convert to a string" do
    item = RVista::POLineItem.load_from_array(@row)
    str = item.to_s
    arr = FasterCSV.parse(str).first

    arr.size.should == 14

    item = RVista::POLineItem.load_from_array(@row2)
    str = item.to_s
    arr = FasterCSV.parse(str).first

    arr.size.should == 14
  end

end
