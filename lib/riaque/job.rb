module Riaque
  class Job
    include Riik::Document

    property :klass
    property :payload

    def enqueue
      self.enqueue_to(Queue.for(klass))
    end
  end
end
