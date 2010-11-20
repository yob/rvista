require File.dirname(__FILE__) + '/test_helper'

describe RVista::PO do

  before(:each) do
    @valid = File.dirname(__FILE__) + "/data/po/valid.txt"
    @valid_quotes = File.dirname(__FILE__) + "/data/po/quotes.txt"
    @invalid_missing_header = File.dirname(__FILE__) + "/data/po/invalid_missing_header.txt"
    @invalid_missing_footer = File.dirname(__FILE__) + "/data/po/invalid_missing_footer.txt"
    @invalid_line = File.dirname(__FILE__) + "/data/po/invalid_line.txt"
    @invalid_doesnt_exist = File.dirname(__FILE__) + "/data/blah.txt"
  end

  it "should correctly init from a file" do
    msg = RVista::PO.load_from_file(@valid)
    msg.should be_a(RVista::PO)
    msg.items.size.should == 38

    validate_msg(msg)
  end

  it "should correctly init from a string" do
    msg = RVista::PO.load_from_string(File.read(@valid))
    msg.should be_a(RVista::PO)
    msg.items.size.should == 38

    validate_msg(msg)
  end

  it "should correctly load a message that contains quotes" do
    msg = RVista::PO.load_from_string(File.read(@valid_quotes))

    msg.should be_a(RVista::PO)
    msg.items.size.should == 11
  end

  it "should throw appropriate exceptions when loading a message fails" do
    lambda {
      msg = RVista::PO.load_from_file(@invalid_missing_header)
    }.should raise_error(RVista::InvalidFileError)

    lambda {
      msg = RVista::PO.load_from_file(@invalid_missing_footer)
    }.should raise_error(RVista::InvalidFileError)

    lambda {
      msg = RVista::PO.load_from_file(@invalid_line)
    }.should raise_error(RVista::InvalidLineItemError)

    lambda {
      msg = RVista::PO.load_from_file(@invalid_doesnt_exist)
    }.should raise_error(RVista::InvalidFileError)
  end

  it "should correctly convert into a string" do
    msg = RVista::PO.load_from_file(@valid)
    content = File.read(@valid)

    msg.to_s.should == content
  end

  private

  # ensures the properties of the supplied RVista::PO object
  # match the properties specified in the @valid file
  def validate_msg(msg)
    msg.sender_id.should == "1111111"
    msg.receiver_id.should == "2222222"
    msg.internal_control_number.should == nil
    msg.po_number.should == "0000009525908"
    msg.po_subset_code.should == nil
    msg.purpose_code.should == "00"
    msg.purpose_desc.should == nil
    msg.date.should == Chronic.parse("2006-09-15")
    msg.myer_code.should == nil
    msg.supply_after.should == nil
    msg.supply_before.should == nil
    msg.advertised_date.should == nil
    msg.department.should == nil
    msg.supplier_ref.should == nil
    msg.buying_location.should == nil
    msg.buying_location_name.should == nil
    msg.delivery_location.should == "1111111"
    msg.delivery_location_name.should == nil
    msg.label_code.should == nil
  end

end
