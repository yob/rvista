require 'rake'
require 'rake/clean'
require 'rake/rdoctask'
require 'rake/testtask'
require "rake/gempackagetask"
require "rubygems"

PKG_VERSION = "0.5.2"
PKG_NAME = "rvista"
PKG_FILE_NAME = "#{PKG_NAME}-#{PKG_VERSION}"

CLEAN.include "**/.*.sw*"

desc "Default Task"
task :default => [ :test ]

# Run all tests
desc "Run all test"
task :test => [ :test_units ]

# Run the unit tests
desc "Run all unit tests"
Rake::TestTask.new("test_units") { |t|
  t.pattern = 'test/unit/**/*_test.rb'
  t.verbose = true
  t.warning = true
}

# Genereate the RDoc documentation
desc "Create documentation"
Rake::RDocTask.new("doc") do |rdoc|
  rdoc.title = "RVista"
  rdoc.rdoc_dir = 'doc/html'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('COPYING')
  rdoc.rdoc_files.include('LICENSE')
  rdoc.rdoc_files.include('lib/**/*.rb')
  rdoc.options << "--inline-source"
end

spec = Gem::Specification.new do |spec|
  spec.name = PKG_NAME
  spec.version = PKG_VERSION
  spec.platform = Gem::Platform::RUBY
  spec.summary = "A small library for reading Vista HDS ecommerce files"
  spec.files =  Dir.glob("{examples,lib,test}/**/**/*") + ["Rakefile"]
  spec.require_path = "lib"
  spec.test_files = Dir[ "test/test_*.rb" ]
  spec.has_rdoc = true
  spec.extra_rdoc_files = %w{README COPYING LICENSE}
  spec.rdoc_options << '--title' << 'rvista Documentation' <<
                       '--main'  << 'README' << '-q'
  spec.add_dependency('fastercsv', '>= 1.2.1')
  spec.author = "James Healy"
  spec.email = "jimmy@deefa.com"
  spec.description = <<END_DESC
  rvista is a small library for reading Vista HDS order files.
END_DESC
end

desc "Generate a gem for rvista"
Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end

desc "Report code statistics (KLOCs, etc) from the application"
task :stats do
  require 'vendor/code_statistics'
  #dirs = [["Library", "lib"],["Functional tests", "test/functional"],["Unit tests", "test/unit"]]
  dirs = [["Library", "lib"],["Unit tests", "test/unit"]]
  CodeStatistics.new(*dirs).to_s
end

