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
  end
end
