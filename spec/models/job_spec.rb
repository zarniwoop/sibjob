require 'spec_helper'

describe Job do
  before(:each) do
    @attr = {
      :summary => "value for summary",
      :description => "value for description",
      :pointvalue => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Job.create!(@attr)
  end

  describe "job completion" do

    it "should report that a job is complete for a sibling if performed" do
      @job = Factory(:job)
      @performer = Factory(:sibling, :email => Factory.next(:email))
      @job.job_records.build(:performer_id => @performer.id)
      @job.save!
      @job.should be_performed_by(@performer, Date.today)
    end

  end
end
