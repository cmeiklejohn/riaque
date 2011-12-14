module Riaque
  class Job
    include Riik::Document

    property :klass
    property :payload

    def self.enqueue(klass, *payload)
      self.new(:klass => klass, :payload => payload).enqueue
    end

    def enqueue
      self.enqueue_to(Queue.for(klass))
    end

    def default_key 
      Digest::SHA1.hexdigest("#{klass}-#{payload}")
    end
  end
end
