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
      before do 
        VCR.use_cassette('creation_of_nonexistent_vector_job') do
          subject.save
        end
      end

      it 'is able to be found by the generated key' do 
        VCR.use_cassette('retrieval_of_valid_vector_job') do
          Job.find(subject.key).should be_an_instance_of(Job)
        end
      end

      it 'has a key derived from the default' do 
        job.default_key.should == job.key
      end

      pending 'can be enqueued'

      pending 'can be enqueued to a particular queue'
      
      it 'returns true when existence is checked' do
        VCR.use_cassette('retrieval_of_valid_vector_job') do
          Job.exists?(VectorJob, 1, 1).should be_true
        end
      end

      it 'returns true when existence is checked' do
        VCR.use_cassette('retrieval_of_invalid_vector_job') do
          Job.exists?(VectorJob, 1, 2).should_not be_true
        end
      end
    end
  end
end
