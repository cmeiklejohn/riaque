module Riaque
  class Worker
    include CoreExt

    attr_accessor :queues

    def initialize(*queues) 
      @queues = queues
    end

    # Start a worker and begin working the queues.
    #
    def work(interval = 5.0)
    end

    # Work a job for a particular queue and dequeue once complete.
    #
    # @param [Symbol] queue to work from.
    #
    def work_queue(queue)
      if job = Riaque.reserve(queue)
        if klass = self.qualified_const_get(job.klass)
          klass.send(:perform, *job.payload)
        end

        job.dequeue
      end
    end

  end
end
