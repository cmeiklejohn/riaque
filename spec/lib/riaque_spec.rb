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
          Queue.for(:vectors).include?(Job.new(:klass => VectorJob, :payload => [1,1])).should be_true
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

      pending 'can be reserved' do 
        VCR.use_cassette('reservation_of_valid_vector_job') do 
          job = Riaque.reserve(:vectors)
          job.should be_an_instance_of(Job)
        end
      end

      context 'once reserved' do 
        before do 
          VCR.use_cassette('reservation_of_valid_vector_job') do 
            job = Riaque.reserve(:vectors)
            job.should be_an_instance_of(Job)
          end
        end

        pending 'will not be reserved again' do 
          VCR.use_cassette('failed_reservation_of_reserved_vector_job') do 
            job = Riaque.reserve(:vectors)
            job.should_not be_an_instance_of(Job)
          end
        end
      end

      pending 'can be worked'
    end
  end
end
