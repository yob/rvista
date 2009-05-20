# coding: utf-8

require 'bigdecimal'

module RVista

  # represents a single line on the purchase order ack. Has attributes like
  # price, qty and description
  class POALineItem

    attr_accessor :line_num, :ean, :description
    attr_accessor :nett_unit_price, :qty_inners, :tax_rate
    attr_accessor :buying_location, :buying_location_name, :delivered_qty
    attr_accessor :status_code, :demand_qty, :rrp, :discount_percent
    attr_accessor :availability_date, :text

    STATUS = {
      1 => "Shipped as ordered",
      2 => "Title substituted",
      6 => "Out of stock - reprinting",
      7 => "Back ordered",
      9 => "Part supply",
      10 => "Part back ordered",
      15 => "Market restricted",
      27 => "ISBN not recognised",
      28 => "Out of print",
      29 => "Customer backordered"
    }

    # returns a new RVista::POALineItem object using the data passed in as an
    # array. The array should have exactly 14 items in it. Refer to the Vista
    # standard to see what those 14 items should be.
    def self.load_from_array(data)
      item = self.new
      raise InvalidLineItemError, 'incorrect number of data points' unless data.size == 20

      item.line_num = data[1].to_i
      item.ean = data[2]
      item.description = data[4]
      item.nett_unit_price = BigDecimal.new(data[5]) unless data[5].nil?
      item.qty_inners = data[7].to_i
      item.tax_rate = BigDecimal.new(data[8]) unless data[8].nil?
      item.buying_location = data[10]
      item.buying_location_name = data[11]
      item.delivered_qty = data[13].to_i
      item.status_code = data[14]
      item.demand_qty = data[15].to_i
      item.rrp = BigDecimal.new(data[16]) unless data[16].nil?
      item.discount_percent = BigDecimal.new(data[17]) unless data[17].nil?
      item.availability_date = data[18] # TODO: convert this to a Date? 
      item.text = data[19]

      return item
    end

    def status_text
      STATUS[status_code.to_i]
    end
    
    # output a string that represents this line item that meets the vista spec
    def to_s
      msg = ""
      msg << "D," 
      msg << "#{line_num},"
      msg << "#{ean},"
      msg << ","
      msg << "#{description},"
      msg << sprintf("%.2f", nett_unit_price) unless nett_unit_price.nil?
      msg << ","
      msg << "1,"
      msg << "#{qty_inners},"
      msg << sprintf("%.2f", tax_rate) unless tax_rate.nil?
      msg << ","
      msg << ","
      msg << "#{buying_location},"
      msg << "#{buying_location_name},"
      msg << ","
      msg << "#{delivered_qty},"
      msg << "#{status_code},"
      msg << "#{demand_qty},"
      msg << sprintf("%.2f", rrp) unless rrp.nil?
      msg << ","
      msg << sprintf("%.2f", discount_percent) unless discount_percent.nil?
      msg << ","
      msg << "#{availability_date},"
      msg << "#{text}"
      return msg
    end
  end
end
