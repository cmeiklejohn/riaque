module Riaque
  class Queue
    include Riik::Document

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
    # @param [Job]
    # @return [Boolean]
    #
    def enqueue(job)
      @jobs ||= []
      @jobs << job.key

      self.save
    end

    # Returns the status of a job existing in a queue.
    #
    # @param [Job]
    # @return [Boolean]
    #
    def include?(job)
      jobs.include?(job.key)
    end

    # Returns the name of the queue to use for a particular job class.
    # 
    # @param [Class] job class
    # @return [String]
    #
    def self.name_for(klass)
      (klass.instance_variable_get("@queue") || :default).to_s
    end

    # Returns the Queue for a particular job class.
    # 
    # @param [Class] job class
    # @return [Queue]
    #
    def self.for(klass)
      instance = self.instance_for(name_for(klass))

      begin
        self.find(instance.default_key)
      rescue Riak::HTTPFailedRequest 
        instance
      end
    end

    # Return the instantiated object for a particular queue name.
    #
    # @param [String] queue name
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
