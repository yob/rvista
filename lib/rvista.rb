# coding: utf-8

require 'andand'
require 'chronic'
require "fastercsv"

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
