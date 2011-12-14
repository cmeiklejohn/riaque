require 'spec_helper'

module Riaque
  describe self do 
    let(:attributes) { [VectorJob, 1, 1] }

    it 'enqueues a job' do
      Riaque.enqueue(*attributes).should be_true
    end

    context 'once enqueued' do 
      before do 
        Riaque.enqueue(*attributes)
      end

      it 'exists as a job' do 
        Job.exist?(*attributes).should be_true
      end

      pending 'exists in a queue'
    end
  end
end
