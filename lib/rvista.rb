# coding: utf-8

require 'chronic'

# faster csv is distributed with ruby 1.9 as "CSV", so we only
# need to load the gem on ruby < 1.9
#
# This shim borrowed from Gregory Brown
# http://ruport.blogspot.com/2008/03/fastercsv-api-shim-for-19.html
#
if RUBY_VERSION > "1.9"
  require "csv"
  unless defined? FasterCSV
    class Object
      FCSV = FasterCSV = CSV
      alias_method :FasterCSV, :CSV
    end
  end
else
  require "fastercsv"
end


require File.dirname(__FILE__) + '/rvista/errors'
require File.dirname(__FILE__) + '/rvista/message'
require File.dirname(__FILE__) + '/rvista/invoice'
require File.dirname(__FILE__) + '/rvista/invoice_line_item'
require File.dirname(__FILE__) + '/rvista/po'
require File.dirname(__FILE__) + '/rvista/po_line_item'
require File.dirname(__FILE__) + '/rvista/poa'
require File.dirname(__FILE__) + '/rvista/poa_line_item'

# Ruby module for reading Vista HDS EDI files
#
# = Basic Usage
#  require 'rubygems'
#  require 'rvista'
#  po = RVista::PO.load_from_file('somefile.txt')
#  puts po.to_s
#
#  poa = RVista::POA.load_from_file('somefile.txt')
#  puts poa.to_s
#
#  inv = RVista::Invoice.load_from_file('somefile.txt')
#  puts inv.to_s
module RVista

end
