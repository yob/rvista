require File.dirname(__FILE__) + '/test_helper'

describe RVista::Invoice do

  before(:each) do
    @valid = File.dirname(__FILE__) + "/data/invoice/valid.txt"
    @invalid_missing_header = File.dirname(__FILE__) + "/data/invoice/invalid_missing_header.txt"
    @invalid_missing_footer = File.dirname(__FILE__) + "/data/invoice/invalid_missing_footer.txt"
    @invalid_line = File.dirname(__FILE__) + "/data/invoice/invalid_line.txt"
    @invalid_doesnt_exist = File.dirname(__FILE__) + "/data/blah.txt"
  end

  it "should correctly load from a file" do
    msg = RVista::Invoice.load_from_file(@valid)

    msg.should be_a(RVista::Invoice)
    msg.items.size.should  == 2
    msg.total_value.should == BigDecimal.new("2200")
    msg.total_qty.should   == BigDecimal.new("5")
    msg.total_gst.should   == BigDecimal.new("200")

    validate_msg(msg)
  end

  # ensure the load_from_file method works as expected
  it "should correctly load from a string" do
    msg = RVista::Invoice.load_from_string(File.read(@valid))

    msg.should be_a(RVista::Invoice)
    msg.items.size.should == 2

    validate_msg(msg)
  end

  it "should throw appropriate exceptions when loading from a file" do
    lambda {
      RVista::Invoice.load_from_file(@invalid_missing_header)
    }.should raise_error(RVista::InvalidFileError)

    lambda {
      msg = RVista::Invoice.load_from_file(@invalid_missing_footer)
    }.should raise_error(RVista::InvalidFileError)

    lambda {
      msg = RVista::Invoice.load_from_file(@invalid_line)
    }.should raise_error(RVista::InvalidLineItemError)

    lambda {
      msg = RVista::Invoice.load_from_file(@invalid_doesnt_exist)
    }.should raise_error(RVista::InvalidFileError)
  end

  it "should correctly convert to a string" do
    msg = RVista::Invoice.load_from_file(@valid)
    content = File.read(@valid)

    msg.to_s.should == content
  end

  private

  # ensures the properties of the supplied RVista::Invoice object
  # match the properties specified in the @valid file
  def validate_msg(msg)
    msg.sender_id.should   == "1111111"
    msg.receiver_id.should == "2222222"
    msg.doc_type.should    == "IN"
    msg.description.should == "Invoice"
    msg.doc_number.should  == "5678"
    msg.doc_date.should    == Chronic.parse("2007-10-11")
    msg.delivery_location.should == "1111111"
    msg.currency.should be_nil
  end
end
