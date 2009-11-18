# coding: utf-8

module RVista

  # Parent class of all 3 vista HDS message types
  class Message #nodoc

    private

    # convert a vista date format
    def vista_string_to_date(str)
      if str.nil? || str.to_s[0,2] == "00" || str.to_s.size != 8
        nil
      else
        year  = "20#{str[6,2]}"
        month = str[3,2]
        day   = str[0,2]
        Chronic.parse("#{year}-#{month}-#{day}")
      end
    end

    def process_date(value)
      if value.respond_to?(:strftime)
        value.strftime("%d-%m-%y")
      else
        value
      end
    end
  end

end
