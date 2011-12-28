module Riaque
  class Worker
    include CoreExt

    # Work a job.
    #
    # @param [Symbol] queue to work from.
    #
    def work(queue)
      if job = Riaque.reserve(queue)
        if klass = self.qualified_const_get(job.klass)
          klass.send(:perform, *job.payload)
        end
      end
    end

  end
end
