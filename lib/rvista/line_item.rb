require 'bigdecimal'

module RVista

  class LineItem

    attr_accessor :line_num, :qualifier, :ean, :description
    attr_accessor :qty, :nett_unit_price, :unit_measure
    attr_accessor :retail_unit_price, :was_unit_price, :discount
    attr_accessor :backorder, :additional_discount, :firm_sale

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
      item.backorder = data[11] == "Y" ? true : false
      item.additional_discount = data[12]
      item.firm_sale = data[13]

      return item
    end
      
  end

end
