require 'spec_helper'

module Riaque
  describe self do 
    it 'enqueues a job' do
      Riaque.enqueue(VectorJob, 1, 1).should be_true
    end
  end
end
