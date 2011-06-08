require 'spec_helper'

describe Job do

  it "should create a new instance given valid attributes" do
    Job.create!(:summary => "value for summary",
      :description => "value for description",
      :pointvalue => 1)
  end

  describe "job list" do
    it "should show a list of jobs remaining to perform" do
      @performer = Factory(:sibling, :email => Factory.next(:email))
      job1 = Factory(:job, :summary => "Job 1")
      job2 = Factory(:job, :summary => "Job 2")
      job3 = Factory(:job, :summary => "Job 3", :sibling_id => @performer.id)
      job2.job_records.build(:performer_id => @performer.id, :performed_on => Date.today)
      job2.save!
      jobs_to_perform = Job.to_do_for_sibling(@performer.id, Date.today)
      jobs_to_perform.should include(job1)
      jobs_to_perform.should include(job3)
      jobs_to_perform.should_not include(job2)
    end

    it "should show performed jobs as remaining if repeatable" do
      @performer = Factory(:sibling, :email => Factory.next(:email))
      job = Factory(:job, :summary => "Job 2", :interval => "repeatable")
      job.job_records.build(:performer_id => @performer.id, :performed_on => Date.today)
      job.save!
      jobs_to_perform = Job.to_do_for_sibling(@performer.id, Date.today)
      jobs_to_perform.should include(job)
    end
  end

  describe "job completion" do

    it "should report that a job is complete for a sibling if performed" do
      @job = Factory(:job)
      @performer = Factory(:sibling, :email => Factory.next(:email))
      @job.job_records.build(:performer_id => @performer.id)
      @job.save!
      @job.should be_performed_by(@performer, Date.today)
    end

    it "should report multiple job completions on same day for repeatable jobs" do
      @job = Factory(:job, :interval => "repeatable")
      @performer = Factory(:sibling, :email => Factory.next(:email))
      @job.job_records.build(:performer_id => @performer.id, :performed_on => Date.today)
      @job.job_records.build(:performer_id => @performer.id, :performed_on => Date.today)
      @job.save!
      @job.performed_by(@performer, Date.today).count.should be(2)
    end

  end

  describe "inactive jobs" do
    it "should not be in the to do list" do
      @performer = Factory(:sibling, :email => Factory.next(:email))
      Factory(:job, :summary => "Job 1", :active => false)
      jobs_to_perform = Job.to_do_for_sibling(@performer.id, Date.today)
      jobs_to_perform.should be_empty
    end
  end
end
