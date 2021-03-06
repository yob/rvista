# coding: utf-8

require 'andand'
require 'chronic'
require 'csv'

require 'rvista/errors'
require 'rvista/message'
require 'rvista/invoice'
require 'rvista/invoice_line_item'
require 'rvista/po'
require 'rvista/po_line_item'
require 'rvista/poa'
require 'rvista/poa_line_item'

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
