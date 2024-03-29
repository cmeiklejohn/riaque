# encoding: UTF-8

PROJECT_ROOT = File.expand_path("../..", __FILE__)
$LOAD_PATH << File.join(PROJECT_ROOT, "lib")

Bundler.require

Dir[File.join(PROJECT_ROOT,"spec/support/**/*.rb")].each {|f| require f}

require 'riaque'

require 'vcr'

VCR.config do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.stub_with :webmock
  c.default_cassette_options = { :record => :none }
end

module Riaque
  class VectorJob
    @queue = :vectors

    def self.perform(x, y) 
      [x,y]
    end
  end

  class StringJob
    def self.perform(argument)
      argument.to_s
    end
  end
end
