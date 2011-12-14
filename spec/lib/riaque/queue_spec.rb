require 'spec_helper'

module Riaque
  describe Queue do 
    subject { queue } 

    let(:queue) { Queue } 

    it 'knows the queue name to retrieve things for if set' do 
      subject.name_for(VectorJob).should == :vectors
    end

    it 'knows the default queue name' do 
      subject.name_for(StringJob).should == :default
    end

    it 'returns the queue for a particular job type' do 
      subject.for(VectorJob).tap do |queue|
        queue.should be_an_instance_of(Queue)
        queue.name.should == :vectors
      end
    end

    context 'for a particular queue' do 
      let(:queue) { Queue.new(:name => :vectors) }

      before do 
        VCR.use_cassette('creation_of_nonexistent_vector_queue') do
          subject.save
        end
      end

      it 'has a name' do 
        subject.name.should == :vectors
      end

      pending 'has a list of jobs' do
        subject.jobs.should == []
      end

      pending 'has a key derived on the default key' do 
        subject.default_key.should == subject.key
      end
    end

    context 'with an existing queue object in riak' do 

      pending 'returns the queue for a particular job type'

      pending 'adds a job to the queue'

    end
  end
end
