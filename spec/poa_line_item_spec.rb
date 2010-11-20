require File.dirname(__FILE__) + '/test_helper'

describe RVista::POALineItem do

  before(:each) do
    @row = []
    @row << "D"
    @row << "1"
    @row << "0701180358"
    @row << nil
    @row << "DIGGING TO AMERICA"
    @row << "10.00"
    @row << "1"
    @row << "0"
    @row << "10.00"
    @row << nil
    @row << "1111111"
    @row << "Some Store"
    @row << nil
    @row << "1"
    @row << "01"
    @row << "1"
    @row << "11.00"
    @row << "40.00"
    @row << "20071015"
    @row << nil
  end

  it "should correctly init from an array" do
    item = RVista::POALineItem.load_from_array(@row)
    item.should be_a(RVista::POALineItem)

    item.line_num.should == 1
    item.ean.should == "0701180358"
    item.description.should == "DIGGING TO AMERICA"
    item.nett_unit_price.should == 10.00
    item.qty_inners.should == 0
    item.tax_rate.should == 10.00
    item.buying_location.should == "1111111"
    item.buying_location_name.should == "Some Store"
    item.delivered_qty.should == 1
    item.status_code.should == "01"
    item.demand_qty.should == 1
    item.rrp.should == 11.00
    item.discount_percent.should == 40.00
    item.availability_date.should == "20071015"
    item.text.should == nil
  end

  it "should throw an appropriate exception when failing to load from an array" do
    lambda {
      item = RVista::POALineItem.load_from_array(%w[D blah])
    }.should raise_error(RVista::InvalidLineItemError)
  end

  it "should return the correct status text" do
    item = RVista::POALineItem.load_from_array(@row)
    item.status_text.should == "Accepted: Title Shipped As Ordered"
  end

  it "should correctly convert to a string" do
    item = RVista::POALineItem.load_from_array(@row)
    str = item.to_s
    arr = FasterCSV.parse(str).first

    arr.size.should == 20
  end

  it "should correctly convert into a string when some decimal values are missing" do
    item = RVista::POALineItem.load_from_array(@row)
    item.nett_unit_price = ""
    item.rrp = ""
    item.tax_rate = ""
    item.discount_percent = ""

    str = item.to_s
    arr = FasterCSV.parse(str).first
    arr.size.should == 20
  end

end
