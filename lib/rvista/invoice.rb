# coding: utf-8

module RVista

  # Represents a single Vista Invoice
  class Invoice

    attr_accessor :sender_id, :receiver_id, :doc_type, :description
    attr_accessor :doc_number, :doc_date, :delivery_location, :currency
    attr_accessor :items
    attr_accessor :total_value, :total_qty, :total_gst

    # creates a new RVista::Invoice object
    def initialize
      @items = []
    end

    # reads a vista invoice file into memory. input should be a string
    # that specifies the file path
    def self.load_from_file(input)
      raise InvalidFileError, 'Invalid file' unless File.exist?(input)
      data = FasterCSV.read(input, :quote_char => "`")
      return self.build_message(data)
    end

    # creates a RVista::Invoice object from a string. Input should
    # be a complete vista file as a string
    def self.load_from_string(input)
      data = FasterCSV.parse(input, :quote_char => "`")
      return self.build_message(data)
    end

    # print a string representation of this order that meets the spec
    def to_s
      # message header
      msg = ""
      msg << "H,"
      msg << "#{sender_id.to_s[0,13]},"
      msg << "#{receiver_id.to_s[0,13]},"
      msg << "#{doc_type.to_s[0,4]},"
      msg << "#{description.to_s[0,30]},"
      msg << "#{doc_number.to_s[0,8]},"
      msg << "#{doc_date.to_s[0,8]},"
      msg << "#{delivery_location.to_s[0,10]},"
      msg << "#{currency.to_s[0,4]}\n"

      total_value = BigDecimal.new("0")
      total_qty   = BigDecimal.new("0")
      total_gst   = BigDecimal.new("0")

      # message line items
      @items.each do |item|
        msg << item.to_s << "\n"
        total_value += item.nett_value + item.gst
        total_qty   += item.qty
        total_gst   += item.gst
      end

      # message summary
      msg << "S,"
      msg << "#{@items.size.to_s},"
      msg << sprintf("%.0f", total_value)
      msg << ","
      msg << sprintf("%.0f", total_qty)
      msg << ","
      msg << sprintf("%.0f", total_gst)
      msg << "\n"

      return msg
    end

    private

    def self.build_message(data)
      raise InvalidFileError, 'File appears to be too short' unless data.size >= 3
      raise InvalidFileError, 'Missing header information' unless data[0][0].eql?("H")
      raise InvalidFileError, 'Missing footer information' unless data[-1][0].eql?("S")

      msg = self.new

      # set message attributes
      msg.sender_id   = data[0][1]
      msg.receiver_id = data[0][2]
      msg.doc_type    = data[0][3]
      msg.description = data[0][4]
      msg.doc_number  = data[0][5]
      msg.doc_date    = data[0][6]
      msg.delivery_location = data[0][7]
      msg.currency    = data[0][8]

      # load each lineitem into the message
      data[1,data.size - 2].each do |row|
        raise InvalidLineItemError, 'Invalid line detected' unless row[0].eql?("D")
        item = InvoiceLineItem.load_from_array(row)
        msg.items << item
      end

      raise InvalidFileError, 'Last line isn\'t a footer' unless data[-1][0].eql?("S")
      raise InvalidFileError, 'Line item count doesn\'t match footer' unless data[-1][1].to_i.eql?(msg.items.size)

      msg.total_value = BigDecimal.new(data[-1][2])
      msg.total_qty   = BigDecimal.new(data[-1][3])
      msg.total_gst   = BigDecimal.new(data[-1][4])

      # return the results
      return msg
    end
  end
end
