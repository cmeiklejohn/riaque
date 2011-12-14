require 'spec_helper'

module Riaque
  describe self do 
    it 'enqueues a job' do
      Riaque.enqueue(VectorJob, 1, 1).should be_true
    end

    context 'once enqueued' do
      before do
        Riaque.enqueue(VectorJob, 1, 1).should be_true
      end

      pending 'exists as a job in riak'

      pending 'exists in one of the riak queue objects'
    end
  end
end
