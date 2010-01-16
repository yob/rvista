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
      case self.status_code.to_i
      when 1  then "Accepted: Title Shipped As Ordered"
      when 2  then "Accepted: Substitute Title Shipped As Ordered"
      when 3  then "Cancelled: Future Publication"
      when 4  then "Cancelled: Future Publication" # date available
      when 5  then "Backordered: Future Publication"
      when 6  then "Cancelled: Out of Stock"
      when 7  then "Backordered: Out of Stock"
      when 8  then "Cancelled: Out of Print"
      when 9  then "Partial Ship: Cancel Rest"
      when 10 then "Partial Ship: Backorder Rest"
      when 11 then "Cancelled: HB Out of Print, PB Available"
      when 12 then "Cancelled: PB Out of Print, HB Available"
      when 13 then "Cancelled: Out of Print, Alt. Edition Available"
      when 14 then "Backordered: Subtitute Title on BO."
      when 15 then "Cancelled: No Rights"
      when 16 then "Cancelled: Not our Publication"
      when 17 then "Accepted: Free Book"
      when 18 then "Cancelled: BO Expired"
      when 19 then "Cancelled: Subscription Only"
      when 20 then "Cancelled: Not Carried"
      when 21 then "Cancelled: Not Carried"
      when 22 then "Cancelled: Import Title"
      when 23 then "Cancelled: Not Available for Wholesale"
      when 24 then "Cancelled: Kits Not Available"
      when 25 then "Cancelled: Not Available"
      when 26 then "Cancelled: New Price From Publisher"
      when 27 then "Cancelled: ISBN Not Recognised"
      when 28 then "Cancelled: Out of Print"
      when 29 then "Backordered: At Customers Request"
      else
        "UNKNOWN"
      end
    end

    # output a string that represents this line item that meets the vista spec
    def to_s
      nil_numeric_values
      normalise_numeric_values

      msg = ""
      msg << "D,"
      msg << "#{line_num},"
      msg << "#{ean},"
      msg << ","
      msg << "#{description},"
      msg << "#{formatted_nett_unit_price},"
      msg << "1,"
      msg << "#{qty_inners},"
      msg << "#{formatted_tax_rate},"
      msg << ","
      msg << "#{buying_location},"
      msg << "#{buying_location_name},"
      msg << ","
      msg << "#{delivered_qty},"
      msg << "#{status_code},"
      msg << "#{demand_qty},"
      msg << "#{formatted_rrp},"
      msg << "#{formatted_discount_percent},"
      msg << "#{availability_date},"
      msg << "#{text}"
      return msg
    end

    private

    # ensure all decimal attributes are BigDecimals
    #
    def nil_numeric_values
      self.nett_unit_price = nil  if self.nett_unit_price.to_s.size == 0
      self.tax_rate = nil         if self.tax_rate.to_s.size == 0
      self.rrp = nil              if self.rrp.to_s.size == 0
      self.discount_percent = nil if self.discount_percent.to_s.size == 0
    end

    # set empty numerics to nil
    #
    def normalise_numeric_values
      self.nett_unit_price = BigDecimal.new(self.nett_unit_price.to_s) unless self.nett_unit_price.nil?
      self.tax_rate = BigDecimal.new(self.tax_rate.to_s) unless self.tax_rate.nil?
      self.rrp = BigDecimal.new(self.rrp.to_s) unless self.rrp.nil?
      self.discount_percent = BigDecimal.new(self.discount_percent.to_s) unless self.discount_percent.nil?
    end

    def formatted_nett_unit_price
      self.nett_unit_price.nil? ? "" : "%.2f" % self.nett_unit_price
    end

    def formatted_tax_rate
      self.tax_rate.nil? ? "" : "%.2f" % self.tax_rate
    end

    def formatted_rrp
      self.rrp.nil? ? "" : "%.2f" % self.rrp
    end

    def formatted_discount_percent
      self.discount_percent.nil? ? "" : "%.2f" % self.discount_percent
    end
  end
end
