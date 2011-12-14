require 'spec_helper'

module Riaque
  describe Job do 
    subject { job } 

    let(:job) { Job.new(:klass => VectorJob, :payload => [1,1]) } 

    it 'contains a klass' do 
      subject.klass.should == VectorJob
    end

    it 'contains the correct payload' do 
      subject.payload.should == [1,1]
    end

    context 'when saved' do 
      subject { job.save } 

      it 'is able to be found by the generated key' do 
        Job.find(job.key).should be_an_instance_of(Job)
      end
    end
  end
end
