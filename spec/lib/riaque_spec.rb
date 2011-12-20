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

      it 'is enqueued' do 
        VCR.use_cassette('retrieval_of_valid_vector_job') do 
          Job.enqueued?(*attributes).should be_true
        end
      end

      it 'exists in a queue' do 
        VCR.use_cassette('retrieval_of_valid_vector_job') do 
          Queue.for(VectorJob).include?(Job.instance_for(*attributes)).should be_true
        end
      end

      it 'can be dequeued' do
        VCR.use_cassette('dequeue_of_valid_vector_job') do 
          Riaque.dequeue(*attributes).should be_true
        end
      end

      context 'once dequeued' do 
        before do 
          VCR.use_cassette('dequeue_of_valid_vector_job') do 
            Riaque.dequeue(*attributes)
          end
        end

        it 'still exists as a job' do
          VCR.use_cassette('retrieval_of_valid_vector_job') do 
            Job.exist?(*attributes).should be_true
          end
        end

        it 'is not enqueued' do 
          VCR.use_cassette('retrieval_of_valid_vector_job_unqueued') do 
            Job.enqueued?(*attributes).should_not be_true
          end
        end
      end

      pending 'can be reserved'

      pending 'can be worked'
    end
  end
end
