require 'spec_helper'

describe JobRecord do

  before(:each) do
    @job = Factory(:job)
    @performer = Factory(:sibling, :email => "performer@bajink.com")
    @inspector = Factory(:sibling, :email => "inspector@bajink.com")
    @job_record = @job.job_records.build(:performer_id => @performer.id)
  end

  describe "validations" do
    it "should require a job" do
      JobRecord.new().should_not be_valid
    end

    it "should require a performer_id" do
      @job_record.performer_id = nil
      @job_record.should_not be_valid
    end

    it "should require a performed date" do
      @job_record.performed_on = nil
      @job_record.should_not be_valid
    end

    it "should set a default performed at date" do
      @job_record.performed_on.should_not be_nil
    end

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
      @job_record.inspect!(@inspector)
      @job_record.inspector.should == @inspector
    end
  end

  describe "one-time job handling" do
    it "should mark a one-time job inactive once inspected" do
      @job.should be_active
      @job_record.inspect!(@inspector)
      @job.reload
      @job.should_not be_active
    end

    it "should mark a one-time job active if uninspected" do
      @job.active = false
      @job.save!
      @job_record.uninspect!
      @job.reload
      @job.should be_active
    end

    it "should mark an uninspectable one-time job inactive if job record created" do
      uninspectable_onetime_job = Factory(:job, :inspectable => false)
      uninspectable_onetime_job.should be_active
      job_rec = uninspectable_onetime_job.job_records.build(:performer_id => @performer.id)
      job_rec.save!
      uninspectable_onetime_job.reload
      uninspectable_onetime_job.should_not be_active
    end

    it "should mark an uninspectable one-time job active if job record destroyed" do
      uninspectable_onetime_job = Factory(:job, :inspectable => false)
      job_rec = uninspectable_onetime_job.job_records.build(:performer_id => @performer.id)
      job_rec.save!
      job_rec.destroy
      uninspectable_onetime_job.reload
      uninspectable_onetime_job.should be_active
    end

    it "should not change the active status of a recurring job" do
      @job.interval = "daily"
      @job.save!
      @job_record.inspect!(@inspector)
      @job.reload
      @job.should be_active
    end
  end

end
