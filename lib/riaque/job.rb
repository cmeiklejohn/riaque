module Riaque
  class Job
    include Riik::Document

    property :klass
    property :payload

    def self.enqueue(klass, *payload)
      instance_for(klass, *payload).enqueue
    end

    def self.exists?(klass, *payload) 
      begin 
        self.find(instance_for(klass, *payload).default_key).present?
      rescue Riak::HTTPFailedRequest 
        false
      end
    end

    def self.instance_for(klass, *payload) 
      self.new(:klass => klass, :payload => payload)
    end

    def enqueue
      self.enqueue_to(Queue.for(klass))
    end

    def default_key 
      Digest::SHA1.hexdigest("#{klass}-#{payload}")
    end
  end
end
