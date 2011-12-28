module Riaque
  class Job
    include CoreExt
    include Document
    include Riik::Document

    property :klass
    property :payload

    # Creates a new job, and pushes it into the appropriate queue for
    # that job.
    #
    # @param  [Class]   job class.
    # @param  [Array]   attributes.
    # @return [Boolean] 
    #
    def self.enqueue(klass, *payload)
      self.new(:klass => klass, :payload => payload).enqueue
    end

    # Attemps to dequeue a job give the job parameters.
    #
    # @param  [Class]   job class.
    # @param  [Array]   attributes.
    # @return [Boolean] 
    #
    def self.dequeue(klass, *payload)
      self.new(:klass => klass, :payload => payload).dequeue
    end

    # Returns if a particular job already exists.
    #
    # @param  [Class]   job class.
    # @param  [Array]   attributes.
    # @return [Boolean]
    #
    def self.exist?(klass, *payload) 
      self.find_by_attributes(:klass => klass, :payload => payload) ? true : false
    end

    # Returns if a particular job already exists in a queue.
    #
    # @param  [Class]   job class.
    # @param  [Array]   attributes.
    # @return [Boolean]
    #
    def self.enqueued?(klass, *payload) 
      if job = self.find_by_attributes(:klass => klass, :payload => payload)
        job.enqueued?
      else
        false
      end
    end

    # Returns if this job in enqueued.
    #
    # @return [Boolean]
    #
    def enqueued?
      queue.include?(self)
    end

    # Return the name of the queue that this job should be
    # enqueued/dequeued to/from.
    #
    # @return [Symbol]
    #
    def queue_name
      if qualified_klass = self.qualified_const_get(klass) 
        queue_name = qualified_klass.instance_variable_get("@queue")
      end

      queue_name || :default
    end

    # Return the queue that this job shouild be enqueued/dequeued
    # to/from.
    #
    # @return [Queue] 
    #
    def queue
      Queue.for(queue_name)
    end

    # Enqueue this job to it's associated queue.
    #
    # @return [Boolean]
    #
    def enqueue
      self.enqueue_to(queue)
    end

    # Dequeue this job from it's associated queue.
    #
    # @return [Boolean]
    #
    def dequeue
      self.dequeue_from(queue)
    end

    # Enqueue this job to a particular queue.
    #
    # @param  [Queue] queue to enqueue job to.
    # @return [Boolean]
    #
    def enqueue_to(specified_queue)
      specified_queue.enqueue(self)
    end

    # Dequeue this job from a particular queue.
    #
    # @param  [Queue] queue from which to dequeue job from.
    # @return [Boolean]
    #
    def dequeue_from(specified_queue)
      specified_queue.dequeue(self)
    end

    # Generates a unique key to be used when creating the associated
    # Riak object.
    #
    # @return [String] key derived from object attributes.
    #
    def default_key 
      Digest::SHA1.hexdigest("riaque:#{klass}-#{payload}")
    end
  end
end
