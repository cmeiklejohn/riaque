module Riaque
  class Queue
    include Document
    include Riik::Document

    property :name
    property :jobs

    # Return list of jobs.
    #
    # @return [Array]
    #
    def jobs
      @jobs || {}
    end

    # Enqueue a job into a particular queue.
    #
    # @param  [Job]
    # @return [Boolean]
    #
    def enqueue(job)
      @jobs ||= {}
      @jobs[job.key] = {}

      self.save
    end

    # Dequeue a job from a particular queue.
    #
    # @param  [Job]
    # @return [Boolean]
    #
    def dequeue(job)
      @jobs = @jobs.delete(job.key)

      self.save
    end

    # Returns the status of a job existing in a queue.
    #
    # @param  [Job]
    # @return [Boolean]
    #
    def include?(job)
      jobs.keys.include?(job.key)
    end

    # Returns the Queue for a particular job class.
    # 
    # @param  [Object] job class or symbol
    # @return [Queue]
    #
    def self.for(name)
      self.find_or_create_by_attributes(:name => name.to_s)
    end

    # Generates a unique key to be used when creating the associated
    # Riak object.
    #
    # @return [String] key derived from object attributes.
    #
    def default_key 
      Digest::SHA1.hexdigest("riaque:#{name}")
    end
  end
end
