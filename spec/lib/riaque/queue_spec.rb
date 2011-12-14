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
      subject.for(VectorJob).should be_an_instance_of(Queue)
    end

    pending 'has a name'

    pending 'has a list of jobs'

    context 'with an existing queue object in riak' do 

      pending 'returns the queue for a particular job type'

      pending 'adds a job to the queue'

    end
  end
end
