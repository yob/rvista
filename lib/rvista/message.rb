require 'rubygems'
require 'fastercsv'
require File.dirname(__FILE__) + '/line_item'
require File.dirname(__FILE__) + '/errors'

module RVista

  class Message

    attr_accessor :sender_id, :receiver_id, :internal_control_number, :po_number
    attr_accessor :po_subset_code, :purpose_code, :purpose_desc, :date
    attr_accessor :myer_code, :supply_after, :supply_before, :advertised_date
    attr_accessor :department, :supplier_ref, :buying_location
    attr_accessor :buying_location_name, :delivery_location
    attr_accessor :delivery_location_name, :label_code
    attr_accessor :items

    def initialize
      @items = []
    end

    def self.load_from_file(input)
      raise InvalidFileError, 'Invalid file' unless File.exist?(input)
      data = FasterCSV.read(input)
      return self.build_message(data)
    end

    def self.load_from_string(input)
      data = FasterCSV.parse(input)
      return self.build_message(data)
    end

    private

    def self.build_message(data)
      raise InvalidFileError, 'File appears to be too short' unless data.size >= 3
      raise InvalidFileError, 'Missing header information' unless data[0][0].eql?("H")
      raise InvalidFileError, 'Missing footer information' unless data[-1][0].eql?("S")

      msg = Message.new

      # set message attributes
      msg.sender_id = data[0][1]
      msg.receiver_id = data[0][2]
      msg.internal_control_number = data[0][3]
      msg.po_number = data[0][4]
      msg.po_subset_code = data[0][5]
      msg.purpose_code = data[0][6]
      msg.purpose_desc = data[0][7]
      msg.date = data[0][8]
      msg.myer_code = data[0][9]
      msg.supply_after = data[0][10]
      msg.supply_before = data[0][11]
      msg.advertised_date = data[0][12]
      msg.department = data[0][13]
      msg.supplier_ref = data[0][14]
      msg.buying_location = data[0][15]
      msg.buying_location_name = data[0][16]
      msg.delivery_location = data[0][17]
      msg.delivery_location_name = data[0][18]
      msg.label_code = data[0][19]

      # load each lineitem into the message
      data[1,data.size - 2].each do |row| 
        raise InvalidLineItemError, 'Invalid line detected' unless row[0].eql?("D")
        item = LineItem.load_from_array(row)
        msg.items << item
      end

      raise InvalidFileError, 'Line item count doesn\'t match footer' unless data[-1][1].to_i.eql?(msg.items.size)

      # return the results
      return msg
    end
  end

end
