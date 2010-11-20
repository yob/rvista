require File.dirname(__FILE__) + '/test_helper'

describe RVista::POA do

  before(:each) do
    @valid = File.dirname(__FILE__) + "/data/poa/valid.txt"
    @invalid_missing_header = File.dirname(__FILE__) + "/data/poa/invalid_missing_header.txt"
    @invalid_missing_footer = File.dirname(__FILE__) + "/data/poa/invalid_missing_footer.txt"
    @invalid_line = File.dirname(__FILE__) + "/data/poa/invalid_line.txt"
    @invalid_doesnt_exist = File.dirname(__FILE__) + "/data/blah.txt"
  end

  it "should correctly load from a file" do
    msg = RVista::POA.load_from_file(@valid)
    msg.should be_a(RVista::POA)
    msg.items.size.should == 2

    validate_msg(msg)
  end

  it "should correctly init from a string" do
    msg = RVista::POA.load_from_string(File.read(@valid))
    msg.should be_a(RVista::POA)
    msg.items.size.should == 2

    validate_msg(msg)
  end

  it "should throw an appropriate exception when loading from a file fails" do
    lambda {
      msg = RVista::POA.load_from_file(@invalid_missing_header)
    }.should raise_error(RVista::InvalidFileError)

    lambda {
      msg = RVista::POA.load_from_file(@invalid_missing_footer)
    }.should raise_error(RVista::InvalidFileError)

    lambda {
      msg = RVista::POA.load_from_file(@invalid_line)
    }.should raise_error(RVista::InvalidLineItemError)

    lambda {
      msg = RVista::POA.load_from_file(@invalid_doesnt_exist)
    }.should raise_error(RVista::InvalidFileError)
  end

  it "should correctly convert to a string" do
    msg = RVista::POA.load_from_file(@valid)
    content = File.read(@valid)

    msg.to_s.should == content
  end

  private

  # ensures the properties of the supplied RVista::POA object
  # match the properties specified in the @valid file
  def validate_msg(msg)
    msg.sender_id.should == "1111111"
    msg.receiver_id.should == "2222222"
    msg.po_number.should == "1234"
    msg.date.should == Chronic.parse("2006-09-15")
    msg.supply_after.should == Chronic.parse("2007-10-10")
    msg.supply_before.should == Chronic.parse("2007-10-30")
    msg.delivery_location.should == "1111111"
    msg.delivery_location_name.should == "Some Store"
  end

end
