# coding: utf-8

module RVista

  # Represents a single Vista Purchase Order Ack (POA).
  class POA

    attr_accessor :sender_id, :receiver_id, :po_number, :date
    attr_accessor :supply_after, :supply_before, :delivery_location
    attr_accessor :delivery_location_name
    attr_accessor :items

    # creates a new RVista::POA object
    def initialize
      @items = []
    end

    # reads a vista poa file into memory. input should be a string 
    # that specifies the file path
    def self.load_from_file(input)
      raise InvalidFileError, 'Invalid file' unless File.exist?(input)
      data = FasterCSV.read(input)
      return self.build_message(data)
    end

    # creates a RVista::POA object from a string. Input should
    # be a complete vista file as a string
    def self.load_from_string(input)
      data = FasterCSV.parse(input)
      return self.build_message(data)
    end

    # print a string representation of this order that meets the spec
    def to_s
      # message header
      msg = ""
      msg << "H,"
      msg << "#{sender_id},"
      msg << "#{receiver_id},"
      msg << ","
      msg << ","
      msg << ","
      msg << ","
      msg << "#{po_number},"
      msg << "#{date},"
      msg << ","
      msg << "#{supply_after},"
      msg << "#{supply_before},"
      msg << "SP,"
      msg << "#{delivery_location},"
      msg << "#{delivery_location_name}\n"
      
      # message line items
      @items.each { |item| msg << item.to_s << "\n"}

      total_qty = @items.inject(0) { |sum, item| sum+item.demand_qty }

      # message summary
      msg << "S,#{@items.size.to_s},#{total_qty}\n"

      return msg
    end

    private

    def self.build_message(data)
      raise InvalidFileError, 'File appears to be too short' unless data.size >= 3
      raise InvalidFileError, 'Missing header information' unless data[0][0].eql?("H")
      raise InvalidFileError, 'Missing footer information' unless data[-1][0].eql?("S")

      msg = self.new

      # set message attributes
      msg.sender_id = data[0][1]
      msg.receiver_id = data[0][2]
      msg.po_number = data[0][7]
      msg.date = data[0][8]
      msg.supply_after = data[0][10]
      msg.supply_before = data[0][11]
      msg.delivery_location = data[0][13]
      msg.delivery_location_name = data[0][14]

      # load each lineitem into the message
      data[1,data.size - 2].each do |row| 
        raise InvalidLineItemError, 'Invalid line detected' unless row[0].eql?("D")
        item = POALineItem.load_from_array(row)
        msg.items << item
      end

      raise InvalidFileError, 'Line item count doesn\'t match footer' unless data[-1][1].to_i.eql?(msg.items.size)

      # return the results
      return msg
    end
  end
end
