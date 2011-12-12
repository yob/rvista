require File.dirname(__FILE__) + '/test_helper'

describe RVista::InvoiceLineItem do

  before(:each) do
    @row = []
    @row << "D"
    @row << "1"
    @row << "1234"
    @row << "EN"
    @row << "9781857230765"
    @row << "Eye of the World"
    @row << "5"
    @row << "EA"
    @row << "19.95"
    @row << "40.00"
    @row << "17.95"
    @row << "Y"
    @row << "89.75"
    @row << "35.90"
    @row << "53.85"
    @row << "2.00"
    @row << "F"
  end

  # ensure the load_from_array method works as expected
  it "should correctly load data from an array" do
    item = RVista::InvoiceLineItem.load_from_array(@row)
    item.should be_a(RVista::InvoiceLineItem)

    item.line_num.should == 1
    item.po_number.should == "1234"
    item.qualifier.should == "EN"
    item.ean.should == "9781857230765"
    item.description.should == "Eye of the World"
    item.qty.should == 5
    item.unit_measure.should == "EA"
    item.rrp.should == 19.95
    item.discount_percent.should == 40.00
    item.nett_unit_price.should == 17.95
    item.gst_inclusive.should be_true
    item.value.should == 89.75
    item.discount_value.should == 35.90
    item.nett_value.should == 53.85
    item.gst.should == 2.00
    item.firm_sale.should be_true
  end

  # ensure the load_from_file method throws the correct exceptions
  # when it encounters a problem
  it "should validate the item" do
    lambda {
      item = RVista::InvoiceLineItem.load_from_array(%w[D blah])
    }.should raise_error(RVista::InvalidLineItemError)
  end

  it "should correctly convert to a string" do
    item = RVista::InvoiceLineItem.load_from_array(@row)
    str = item.to_s
    arr = CSV.parse(str).first

    arr.size.should == 17
  end

end


