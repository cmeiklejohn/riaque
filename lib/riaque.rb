require "riaque/version"
require "riik"

module Riaque
  autoload :Job,     "riaque/job"
  autoload :Queue,   "riaque/queue"
  autoload :CoreExt, "riaque/core_ext"

  class << self

    # Enqueue a job.
    #
    # @param  [Class]   job class.
    # @param  [Array]   attributes.
    # @return [Boolean]
    #
    def enqueue(klass, *payload)
      Job.enqueue(klass, *payload)
    end

  end
end
