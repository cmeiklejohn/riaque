# encoding: UTF-8

require File.expand_path('../lib/riaque/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Christopher Meiklejohn"]
  gem.email         = ["cmeiklejohn@criticalpair.com"]
  gem.description   = %q{Process background jobs persisted in Riak.}
  gem.summary       = %q{Process background jobs persisted in Riak.}
  gem.homepage      = "http://criticalpair.com"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "riaque"
  gem.require_paths = ["lib"]
  gem.version       = Riaque::VERSION

  gem.add_dependency('riik')

  gem.add_development_dependency('yard')
  gem.add_development_dependency('rdoc')
  gem.add_development_dependency('redcarpet')

  gem.add_development_dependency('vcr')
  gem.add_development_dependency('webmock')

  gem.add_development_dependency('rspec')
  gem.add_development_dependency('rake','~> 0.9.2')

  gem.add_development_dependency('ripple')
  gem.add_development_dependency('tddium')

  gem.add_development_dependency('guard')
  gem.add_development_dependency('guard-rspec')
  gem.add_development_dependency('guard-yard')
  gem.add_development_dependency('guard-ctags-bundler')
end
