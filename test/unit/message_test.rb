$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')

require 'test/unit'
require 'rvista'

class MessageTest < Test::Unit::TestCase

  VALID = File.dirname(__FILE__) + "/../data/valid.txt"
  INVALID_MISSING_HEADER = File.dirname(__FILE__) + "/../data/invalid_missing_header.txt"
  INVALID_MISSING_FOOTER = File.dirname(__FILE__) + "/../data/invalid_missing_footer.txt"
  INVALID_LINE = File.dirname(__FILE__) + "/../data/invalid_line.txt"
  INVALID_DOESNT_EXIST = File.dirname(__FILE__) + "/../data/blah.txt"

  # ensure the load_from_file method works as expected
  def test_load_from_file
    msg = RVista::Message.load_from_file(VALID)
    assert_kind_of RVista::Message, msg
    assert_equal msg.items.size, 38

    validate_msg(msg)
      
  end

  # ensure the load_from_file method works as expected
  def test_load_from_string
    msg = RVista::Message.load_from_string(File.read(VALID))
    assert_kind_of RVista::Message, msg
    assert_equal msg.items.size, 38
    
    validate_msg(msg)
  end

  # ensure the load_from_file method throws the correct exceptions
  # when it encounters a problem
  def test_product_validation
    
    assert_raise(RVista::InvalidFileError) {
      msg = RVista::Message.load_from_file(INVALID_MISSING_HEADER)
    }

    assert_raise(RVista::InvalidFileError) {
      msg = RVista::Message.load_from_file(INVALID_MISSING_FOOTER)
    }
    
    assert_raise(RVista::InvalidLineItemError) {
      msg = RVista::Message.load_from_file(INVALID_LINE)
    }

    assert_raise(RVista::InvalidFileError) {
      msg = RVista::Message.load_from_file(INVALID_DOESNT_EXIST)
    }

  end

  private

  # ensures the properties of the supplied RVista::Message object
  # match the properties specified in the VALID file
  def validate_msg(msg)
    assert_equal msg.sender_id, "1111111"
    assert_equal msg.receiver_id, "2222222"
    assert_equal msg.internal_control_number, nil
    assert_equal msg.po_number, "0000009525908"
    assert_equal msg.po_subset_code, nil
    assert_equal msg.purpose_code, "00"
    assert_equal msg.purpose_desc, nil
    assert_equal msg.date, "060915"
    assert_equal msg.myer_code, nil
    assert_equal msg.supply_after, "000000"
    assert_equal msg.supply_before, "000000"
    assert_equal msg.advertised_date, nil
    assert_equal msg.department, nil
    assert_equal msg.supplier_ref, nil
    assert_equal msg.buying_location, nil
    assert_equal msg.buying_location_name, nil
    assert_equal msg.delivery_location, "1111111"
    assert_equal msg.delivery_location_name, nil
    assert_equal msg.label_code, nil
  end

end


