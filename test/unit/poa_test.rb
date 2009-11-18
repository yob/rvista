$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')

require 'test/unit'
require 'rvista'

class POATest < Test::Unit::TestCase

  VALID = File.dirname(__FILE__) + "/../data/poa/valid.txt"
  INVALID_MISSING_HEADER = File.dirname(__FILE__) + "/../data/poa/invalid_missing_header.txt"
  INVALID_MISSING_FOOTER = File.dirname(__FILE__) + "/../data/poa/invalid_missing_footer.txt"
  INVALID_LINE = File.dirname(__FILE__) + "/../data/poa/invalid_line.txt"
  INVALID_DOESNT_EXIST = File.dirname(__FILE__) + "/../data/blah.txt"

  # ensure the load_from_file method works as expected
  def test_load_from_file
    msg = RVista::POA.load_from_file(VALID)
    assert_kind_of RVista::POA, msg
    assert_equal msg.items.size, 2

    validate_msg(msg)
      
  end

  # ensure the load_from_file method works as expected
  def test_load_from_string
    msg = RVista::POA.load_from_string(File.read(VALID))
    assert_kind_of RVista::POA, msg
    assert_equal msg.items.size, 2
    
    validate_msg(msg)
  end

  # ensure the load_from_file method throws the correct exceptions
  # when it encounters a problem
  def test_product_validation
    
    assert_raise(RVista::InvalidFileError) {
      msg = RVista::POA.load_from_file(INVALID_MISSING_HEADER)
    }

    assert_raise(RVista::InvalidFileError) {
      msg = RVista::POA.load_from_file(INVALID_MISSING_FOOTER)
    }
    
    assert_raise(RVista::InvalidLineItemError) {
      msg = RVista::POA.load_from_file(INVALID_LINE)
    }

    assert_raise(RVista::InvalidFileError) {
      msg = RVista::POA.load_from_file(INVALID_DOESNT_EXIST)
    }

  end

  def test_to_s
    msg = RVista::POA.load_from_file(VALID)
    content = File.read(VALID)
    assert_equal content, msg.to_s
  end

  private

  # ensures the properties of the supplied RVista::POA object
  # match the properties specified in the VALID file
  def validate_msg(msg)
    assert_equal msg.sender_id, "1111111"
    assert_equal msg.receiver_id, "2222222"
    assert_equal msg.po_number, "1234"
    assert_equal msg.date, Chronic.parse("2006-09-15")
    assert_equal msg.supply_after, Chronic.parse("2007-10-10")
    assert_equal msg.supply_before, Chronic.parse("2007-10-30")
    assert_equal msg.delivery_location, "1111111"
    assert_equal msg.delivery_location_name, "Some Store"
  end

end


