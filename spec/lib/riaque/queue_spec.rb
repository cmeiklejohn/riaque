require 'spec_helper'

module Riaque
  describe Queue do 
    subject { queue } 

    let(:queue) { Queue } 

    it 'returns the queue for a particular job type' do 
      VCR.use_cassette('retrieval_of_invalid_vector_queue') do
        subject.for(:vectors).tap do |queue|
          queue.should be_an_instance_of(Queue)
          queue.name.should == 'vectors'
        end
      end
    end

    context 'for a particular queue' do 
      let(:queue) { Queue.new(:name => 'vectors') }

      before do 
        VCR.use_cassette('creation_of_nonexistent_vector_queue') do
          subject.save
        end
      end

      it 'has a name' do 
        subject.name.should == 'vectors'
      end

      it 'has a list of jobs' do
        subject.jobs.should == {}
      end

      it 'has a key derived on the default key' do 
        subject.default_key.should == subject.key
      end

      it 'returns the queue for a queue name' do
        VCR.use_cassette('retrieval_of_valid_vector_queue') do
          Queue.for(:vectors).should_not be_nil
        end
      end

      context 'with a job' do 
        let(:job) { Job.new(:klass => VectorJob, :payload => [1,1]) } 

        let(:queue) do
          VCR.use_cassette('retrieval_of_valid_vector_queue') do
            Queue.for(:vectors)
          end
        end
       
        before do 
          VCR.use_cassette('creation_of_nonexistent_vector_job') do
            job.save
          end
        end
        
        it 'adds a job to the queue' do 
          VCR.use_cassette('update_of_vector_queue') do
            subject.enqueue(job).should be_true
          end

          subject.jobs.should include(job.key)
        end
      end

      context 'with a queued job' do 
        let(:job) { Job.new(:klass => VectorJob, :payload => [1,1]) } 

        let(:queue) do
          VCR.use_cassette('retrieval_of_valid_vector_queue') do
            Queue.for(:vectors)
          end
        end
       
        before do 
          VCR.use_cassette('creation_of_nonexistent_vector_job') do
            job.save
          end

          VCR.use_cassette('update_of_vector_queue') do
            subject.enqueue(job).should be_true
          end
        end

        it 'can find the next available job' do 
          queue.next_availability.should == job.key
        end

        it 'can make a reservation' do 
          VCR.use_cassette('reservation_of_valid_vector_job') do 
            queue.make_reservation(job.key)
            queue.jobs.keys.should include(job.key)
          end
        end
      end
    end
  end
end
