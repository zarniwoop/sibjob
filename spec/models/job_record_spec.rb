require 'spec_helper'

describe JobRecord do

  before(:each) do
    @job = Factory(:job)
    @performer = Factory(:sibling, :email => "performer@bajink.com")
    @inspector = Factory(:sibling, :email => "inspector@bajink.com")
    @job_record = @job.job_records.build(:performer_id => @performer.id,
                                         :inspector_id => @inspector.id)
  end

  it "should require a job" do
    JobRecord.new().should_not be_valid
  end

  describe "validations" do
    it "should create a new instance given valid attributes" do
      @job.job_records.build(:performer_id => @performer.id)
      @job.save!
    end
  end


  describe "sibling associations" do

    before(:each) do
      @job_record.save
    end

    it "should have a performer attribute" do
      @job_record = @job.job_records.build()
      @job_record.should respond_to(:performer)
    end

    it "should have the right associated performer" do
      @job_record.performer_id.should == @performer.id
      @job_record.performer.should == @performer
    end

    it "should have an inspector attribute" do
      @job_record.should respond_to(:inspector)
    end

    it "should have the right associated inspector" do
      @job_record.inspector_id.should == @inspector.id
      @job_record.inspector.should == @inspector
    end
  end

  describe "validations" do

    it "should require a performer_id" do
      @job_record.performer_id = nil
      @job_record.should_not be_valid
    end

  end


end
