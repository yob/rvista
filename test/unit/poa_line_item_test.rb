$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')

require 'test/unit'
require 'rvista'
require 'fastercsv'

class POALineItemTest < Test::Unit::TestCase

  def setup
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

  # ensure the load_from_array method works as expected
  def test_load_from_array
    item = RVista::POALineItem.load_from_array(@row)
    assert_kind_of RVista::POALineItem, item

    assert_equal item.line_num, 1
    assert_equal item.ean, "0701180358"
    assert_equal item.description, "DIGGING TO AMERICA"
    assert_equal item.nett_unit_price, 10.00
    assert_equal item.qty_inners, 0
    assert_equal item.tax_rate, 10.00
    assert_equal item.buying_location, "1111111"
    assert_equal item.buying_location_name, "Some Store"
    assert_equal item.delivered_qty, 1
    assert_equal item.status_code, "01"
    assert_equal item.demand_qty, 1
    assert_equal item.rrp, 11.00
    assert_equal item.discount_percent, 40.00
    assert_equal item.availability_date, "20071015"
    assert_equal item.text, nil
  end

  # ensure the load_from_file method throws the correct exceptions
  # when it encounters a problem
  def test_product_validation
    
    assert_raise(RVista::InvalidLineItemError) {
      item = RVista::POALineItem.load_from_array(%w[D blah])
    }

  end

  def test_to_s
    item = RVista::POALineItem.load_from_array(@row)
    str = item.to_s
    arr = FasterCSV.parse(str).first

    assert_equal 20, arr.size
  end

end


