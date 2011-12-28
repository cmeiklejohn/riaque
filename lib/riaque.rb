require "riaque/version"
require "riik"

module Riaque
  autoload :Job,      "riaque/job"
  autoload :Queue,    "riaque/queue"
  autoload :Worker,   "riaque/worker"
  autoload :Document, "riaque/document"
  autoload :CoreExt,  "riaque/core_ext"

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

    # Dequeue a job.
    #
    # @param  [Class]   job class.
    # @param  [Array]   attributes.
    # @return [Boolean]
    #
    def dequeue(klass, *payload)
      Job.dequeue(klass, *payload)
    end

    # Reserve a job.
    #
    # @param  [Symbol] queue
    # @return [Job]
    #
    def reserve(queue)
    end

  end
end
