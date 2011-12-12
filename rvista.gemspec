Gem::Specification.new do |spec|
  spec.name = "rvista"
  spec.version = "0.6.7"
  spec.summary = "A small library for reading Vista HDS ecommerce files"
  spec.description = "rvista is a small library for reading Vista HDS files."
  spec.files =  Dir.glob("{examples,lib}/**/**/*") + ["Rakefile"]
  spec.test_files = Dir[ "test/test_*.rb" ]
  spec.has_rdoc = true
  spec.extra_rdoc_files = %w{README COPYING LICENSE CHANGELOG}
  spec.rdoc_options << '--title' << 'rvista Documentation' <<
                       '--main'  << 'README' << '-q'
  spec.author = "James Healy"
  spec.email = "jimmy@deefa.com"
  spec.homepage = "https://github.com/yob/rvista"

  spec.required_ruby_version = ">=1.9.1"

  spec.add_development_dependency('rake')
  spec.add_development_dependency('rspec', "~> 2.1")

  spec.add_dependency('andand')
  spec.add_dependency('chronic')
end
