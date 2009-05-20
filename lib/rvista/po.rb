# coding: utf-8

module RVista

  # Represents a single Vista message (purchase order).
  class PO

    attr_accessor :sender_id, :receiver_id, :internal_control_number, :po_number
    attr_accessor :po_subset_code, :purpose_code, :purpose_desc, :date
    attr_accessor :myer_code, :supply_after, :supply_before, :advertised_date
    attr_accessor :department, :supplier_ref, :buying_location
    attr_accessor :buying_location_name, :delivery_location
    attr_accessor :delivery_location_name, :label_code
    attr_accessor :items

    # creates a new RVista::PO object
    def initialize
      @items = []
    end

    # reads a vista text file into memory. input should be a string 
    # that specifies the file path
    def self.load_from_file(input)
      raise InvalidFileError, 'Invalid file' unless File.exist?(input)
      data = FasterCSV.read(input)
      return self.build_message(data)
    end

    # creates a RVista::Message object from a string. Input should
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
      msg << "#{internal_control_number},"
      msg << "#{po_number},"
      msg << "#{po_subset_code},"
      msg << "#{purpose_code},"
      msg << "#{purpose_desc},"
      msg << "#{date},"
      msg << "#{myer_code},"
      msg << "#{supply_after},"
      msg << "#{supply_before},"
      msg << "#{advertised_date},"
      msg << "#{department},"
      msg << "#{supplier_ref},"
      msg << "#{buying_location},"
      msg << "#{buying_location_name},"
      msg << "#{delivery_location},"
      msg << "#{delivery_location_name},"
      msg << "#{label_code}\n"
      
      # message line items
      @items.each { |item| msg << item.to_s << "\n"}

      # message summary
      msg << "S,#{@items.size.to_s},,\n"


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
        item = POLineItem.load_from_array(row)
        msg.items << item
      end

      raise InvalidFileError, 'Line item count doesn\'t match footer' unless data[-1][1].to_i.eql?(msg.items.size)

      # return the results
      return msg
    end
  end

  class Message < PO

    def initialize
      $stderr.puts "WARNING: RVista::Message is a deprecated class. Please use RVista::PO instead."
      super
    end
  end
end
