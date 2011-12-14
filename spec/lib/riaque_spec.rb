require 'spec_helper'

module Riaque
  describe self do 
    let(:attributes) { [VectorJob, 1, 1] }

    it 'enqueues a job' do
      VCR.use_cassette('creation_of_nonexistent_vector_job') do 
        Riaque.enqueue(*attributes).should be_true
      end
    end

    context 'once enqueued' do 
      before do 
        VCR.use_cassette('creation_of_nonexistent_vector_job') do 
          Riaque.enqueue(*attributes)
        end
      end

      it 'exists as a job' do 
        VCR.use_cassette('retrieval_of_valid_vector_job') do 
          Job.exist?(*attributes).should be_true
        end
      end

      pending 'exists in a queue'
    end
  end
end
