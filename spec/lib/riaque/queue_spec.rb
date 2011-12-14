require 'spec_helper'

module Riaque
  describe Queue do 
    subject { queue } 

    let(:queue) { Queue } 

    it 'knows the queue name to retrieve things for if set' do 
      subject.name_for(VectorJob).should == 'vectors'
    end

    it 'knows the default queue name' do 
      subject.name_for(StringJob).should == 'default'
    end

    it 'returns the queue for a particular job type' do 
      VCR.use_cassette('retrieval_of_invalid_vector_queue') do
        subject.for(VectorJob).tap do |queue|
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
        subject.jobs.should == []
      end

      it 'has a key derived on the default key' do 
        subject.default_key.should == subject.key
      end

      it 'returns the queue for a particular job type' do 
        VCR.use_cassette('retrieval_of_valid_vector_queue') do
          Queue.for(VectorJob).should_not be_nil
        end
      end

      pending 'adds a job to the queue'
    end
  end
end
