require 'bigdecimal'

module RVista

  # represents a single line on an invoice. Has attributes like
  # price, qty and description
  class InvoiceLineItem

    attr_accessor :line_num, :po_number, :qualifier, :ean, :description
    attr_accessor :qty, :unit_measure, :rrp, :discount_percent
    attr_accessor :nett_unit_price, :gst_inclusive, :value
    attr_accessor :discount_value, :nett_value, :gst, :firm_sale

    # returns a new RVista::POALineItem object using the data passed in as an
    # array. The array should have exactly 14 items in it. Refer to the Vista
    # standard to see what those 14 items should be.
    def self.load_from_array(data)
      item = self.new
      raise InvalidLineItemError, 'incorrect number of data points' unless data.size == 17

      item.line_num = data[1].to_i
      item.po_number = data[2]
      item.qualifier = data[3]
      item.ean = data[4]
      item.description = data[5]
      item.qty = data[6].to_i
      item.unit_measure = data[7]
      item.rrp = BigDecimal.new(data[8]) unless data[8].nil?
      item.discount_percent = BigDecimal.new(data[9]) unless data[9].nil?
      item.nett_unit_price = BigDecimal.new(data[10]) unless data[10].nil?
      if data[11].eql?("Y")
        item.gst_inclusive = true
      else
        item.gst_inclusive = false
      end
      item.value = BigDecimal.new(data[12]) unless data[12].nil?
      item.discount_value = BigDecimal.new(data[13]) unless data[13].nil?
      item.nett_value = BigDecimal.new(data[14]) unless data[14].nil?
      item.gst = BigDecimal.new(data[15]) unless data[15].nil?
      if data[16].eql?("F")
        item.firm_sale = true
      else
        item.firm_sale = false
      end

      return item
    end
    
    # output a string that represents this line item that meets the vista spec
    def to_s
      msg = ""
      msg << "D," 
      msg << "#{line_num},"
      msg << "#{po_number},"
      msg << "#{qualifier},"
      msg << "#{ean},"
      msg << "#{description},"
      msg << "#{qty},"
      msg << "#{unit_measure},"
      msg << sprintf("%.2f", rrp) unless rrp.nil?
      msg << ","
      msg << sprintf("%.2f", discount_percent) unless discount_percent.nil?
      msg << ","
      msg << sprintf("%.2f", nett_unit_price) unless nett_unit_price.nil?
      msg << ","
      if gst_inclusive
        msg << "Y,"
      else
        msg << ","
      end
      msg << sprintf("%.2f", value) unless value.nil?
      msg << ","
      msg << sprintf("%.2f", discount_value) unless discount_value.nil?
      msg << ","
      msg << sprintf("%.2f", nett_value) unless nett_value.nil?
      msg << ","
      msg << sprintf("%.2f", gst) unless gst.nil?
      msg << ","
      if firm_sale
        msg << "F"
      end

      return msg
    end
  end
end
