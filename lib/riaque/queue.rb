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

    # Returns the name of the queue to use for a particular job class.
    # 
    # @param [Class] job class
    # @return [String]
    #
    def self.name_for(klass)
      klass.instance_variable_get("@queue") || :default
    end

    # Returns the Queue for a particular job class.
    # 
    # @param [Class] job class
    # @return [Queue]
    #
    def self.for(klass)
      self.instance_for(name_for(klass))
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
