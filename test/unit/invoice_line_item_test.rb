$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')

require 'test/unit'
require 'rvista'
require 'fastercsv'

class InvoiceLineItemTest < Test::Unit::TestCase

  def setup
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
  def test_load_from_array
    item = RVista::InvoiceLineItem.load_from_array(@row)
    assert_kind_of RVista::InvoiceLineItem, item

    assert_equal item.line_num, 1
    assert_equal item.po_number, "1234"
    assert_equal item.qualifier, "EN"
    assert_equal item.ean, "9781857230765"
    assert_equal item.description, "Eye of the World"
    assert_equal item.qty, 5
    assert_equal item.unit_measure, "EA"
    assert_equal item.rrp, 19.95
    assert_equal item.discount_percent, 40.00
    assert_equal item.nett_unit_price, 17.95
    assert_equal item.gst_inclusive, true
    assert_equal item.value, 89.75
    assert_equal item.discount_value, 35.90
    assert_equal item.nett_value, 53.85
    assert_equal item.gst, 2.00
    assert_equal item.firm_sale, true
  end

  # ensure the load_from_file method throws the correct exceptions
  # when it encounters a problem
  def test_product_validation
    assert_raise(RVista::InvalidLineItemError) {
      item = RVista::InvoiceLineItem.load_from_array(%w[D blah])
    }
  end

  def test_to_s
    item = RVista::InvoiceLineItem.load_from_array(@row)
    str = item.to_s
    arr = FasterCSV.parse(str).first

    assert_equal 17, arr.size
  end

end


