module Riaque
  class Worker
    include CoreExt

    # Start a worker and begin working the queues.
    #
    def work; end

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
