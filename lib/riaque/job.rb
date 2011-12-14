module Riaque
  class Job
    include Riik::Document

    property :klass
    property :payload

    # Creates a new job, and pushes it into the appropriate queue for
    # that job.
    #
    # @param [Class] job class.
    # @param [Array] attributes.
    # @return [Boolean] 
    #
    def self.enqueue(klass, *payload)
      instance_for(klass, *payload).enqueue
    end

    # Returns if a particular job already exists.
    #
    # @param [Class] job class.
    # @param [Array] attributes.
    # @return [Boolean]
    #
    def self.exist?(klass, *payload) 
      begin 
        self.find(instance_for(klass, *payload).default_key).present?
      rescue Riak::HTTPFailedRequest 
        false
      end
    end

    # Returns instantiated Job for a particular set of attributes.
    #
    # @param [Class] job class.
    # @param [Array] attributes.
    # @return [Job]
    #
    def self.instance_for(klass, *payload) 
      self.new(:klass => klass, :payload => payload)
    end

    # Enqueue this job to it's associated queue.
    #
    # @return [Boolean]
    #
    def enqueue
      self.enqueue_to(Queue.for(klass))
    end

    # Enqueue this job to a particular queue.
    #
    # @param [Queue] queue to enqueue job to.
    # @return [Boolean]
    #
    def enqueue_to(queue)
      queue.enqueue(self)
    end

    # Generates a unique key to be used when creating the associated
    # Riak object.
    #
    # @return [String] key derived from object attributes.
    #
    def default_key 
      Digest::SHA1.hexdigest("#{klass}-#{payload}")
    end
  end
end
