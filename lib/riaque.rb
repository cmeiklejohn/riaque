require "riaque/version"

module Riaque
  autoload :Job, "riaque/job"

  class << self
    def enqueue(klass, *args)
      true
    end
  end
end
