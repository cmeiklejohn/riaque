require "riaque/version"
require "riik"

module Riaque
  autoload :Job,   "riaque/job"
  autoload :Queue, "riaque/queue"

  class << self
    def enqueue(klass, *payload)
      Job.enqueue(klass, *payload)
    end
  end
end
