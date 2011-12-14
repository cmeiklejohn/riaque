require "riaque/version"
require "riik"

module Riaque
  autoload :Job,   "riaque/job"
  autoload :Queue, "riaque/queue"

  class << self
    def enqueue(klass, *args)
      Job.create(:class => klass, :payload => args).enqueue
    end
  end
end
