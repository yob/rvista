# coding: utf-8

require 'bigdecimal'

module RVista

  # represents a single line on the purchase order. Has attributes like
  # price, qty and description
  class POLineItem

    attr_accessor :line_num, :qualifier, :ean, :description
    attr_accessor :qty, :nett_unit_price, :unit_measure
    attr_accessor :retail_unit_price, :was_unit_price, :discount
    attr_accessor :backorder, :additional_discount, :firm_sale

    # returns a new RVista::LineItem object using the data passed in as an
    # array. The array should have exactly 14 items in it. Refer to the Vista
    # standard to see what those 14 items should be.
    def self.load_from_array(data)
      item = self.new
      raise InvalidLineItemError, 'incorrect number of data points' unless data.size == 14

      item.line_num = data[1].to_i
      item.qualifier = data[2]
      item.ean = data[3]
      item.description = data[4]
      item.qty = data[5].to_i
      item.nett_unit_price = BigDecimal.new(data[6]) unless data[6].nil?
      item.unit_measure = data[7]
      item.retail_unit_price = BigDecimal.new(data[8]) unless data[8].nil?
      item.was_unit_price = BigDecimal.new(data[9]) unless data[9].nil?
      item.discount = data[10].to_i unless data[10].nil?
      item.backorder = data[11] == "N" ? false : true
      item.additional_discount = data[12]
      item.firm_sale = data[13]

      return item
    end
    
    # output a string that represents this line item that meets the vista spec
    def to_s
      msg = ""
      msg << "D," 
      msg << "#{line_num.to_s},"
      msg << "#{qualifier},"
      msg << "#{ean},"
      msg << "#{description},"
      msg << "#{qty.to_s},"
      msg << sprintf("%.2f", nett_unit_price) unless nett_unit_price.nil?
      msg << ","
      msg << "#{unit_measure},"
      msg << sprintf("%.2f", retail_unit_price) unless retail_unit_price.nil?
      msg << ","
      msg << sprintf("%.2f", was_unit_price) unless was_unit_price.nil?
      msg << ","
      msg << "#{discount.to_s},"
      if backorder == true
        msg << "Y,"
      else
        msg << "N,"
      end
      msg << "#{additional_discount},"
      msg << "#{firm_sale}"
      return msg
    end
      
  end

  class LineItem < POLineItem
    def initialize
      $stderr.puts "WARNING: LineItem is a deprecated class. Please use POLineItem instead."
    end
  end
end
