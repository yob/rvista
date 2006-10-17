$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')

require 'test/unit'
require 'rvista'

class LineItemTest < Test::Unit::TestCase

  def setup
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
  end

  # ensure the load_from_array method works as expected
  def test_load_from_array
    item = RVista::LineItem.load_from_array(@row)
    assert_kind_of RVista::LineItem, item

    assert_equal item.line_num, 1
    assert_equal item.qualifier, "IB"
    assert_equal item.ean, "0701180358"
    assert_equal item.description, "DIGGING TO AMERICA"
    assert_equal item.qty, 3
    assert_equal item.nett_unit_price, 0.00
    assert_equal item.unit_measure, "EA"
    assert_equal item.retail_unit_price, nil
    assert_equal item.was_unit_price, nil
    assert_equal item.discount, 43
    assert_equal item.backorder, true
    assert_equal item.additional_discount, nil
    assert_equal item.firm_sale, nil
  end

  # ensure the load_from_file method throws the correct exceptions
  # when it encounters a problem
  def test_product_validation
    
    assert_raise(RVista::InvalidLineItemError) {
      item = RVista::LineItem.load_from_array(%w[D blah])
    }

  end

end


