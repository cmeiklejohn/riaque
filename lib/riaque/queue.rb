module Riaque
  class Queue
    include Riik::Document
    include CoreExt

    property :name
    property :jobs

    # Return list of jobs.
    #
    # @return [Array]
    #
    def jobs
      @jobs || []
    end

    # Enqueue a job into a particular queue.
    #
    # @param  [Job]
    # @return [Boolean]
    #
    def enqueue(job)
      @jobs ||= []
      @jobs << job.key

      self.save
    end

    # Dequeue a job from a particular queue.
    #
    # @param  [Job]
    # @return [Boolean]
    #
    def dequeue(job)
      @jobs = @jobs.reject { |j| j == job.key }

      self.save
    end

    # Returns the status of a job existing in a queue.
    #
    # @param  [Job]
    # @return [Boolean]
    #
    def include?(job)
      jobs.include?(job.key)
    end

    # Returns the name of the queue to use for a particular job class.
    # 
    # @param  [Class] job class
    # @return [String]
    #
    def self.name_for(klass)
      (klass.instance_variable_get("@queue") || :default).to_s
    end

    # Returns the Queue for a particular job class.
    # 
    # @param  [Class] job class
    # @return [Queue]
    #
    def self.for(klass)
      instance = self.instance_for(name_for(CoreExt.qualified_const_get(klass)))

      begin
        self.find(instance.default_key)
      rescue Riak::HTTPFailedRequest 
        instance
      end
    end

    # Returns if a particular job is enqueued in it's default queue.
    # 
    # @param  [Job]
    # @return [Boolean]
    #
    def self.contains?(job)
      Queue.for(job.klass).include?(job)
    end

    # Return the instantiated object for a particular queue name.
    #
    # @param  [String] queue name
    # @return [Queue]
    #
    def self.instance_for(name)
      self.new(:name => name)
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
