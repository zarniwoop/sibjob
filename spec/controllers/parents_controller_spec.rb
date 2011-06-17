require 'spec_helper'

describe ParentsController do
  render_views

  describe "GET 'index'" do
    before(:each) do
      @sibling1 = Factory(:sibling, :email => "sibling1@example.com")
      @sibling2 = Factory(:sibling, :email => "sibling2@example.com")
      @sibling3 = Factory(:sibling, :email => "sibling3@example.com")
    end

    it "should show a list of siblings" do
      get :index

      response.should have_selector("span.sibling", :content => @sibling1.display_name)
      response.should have_selector("span.sibling", :content => @sibling2.display_name)
      response.should have_selector("span.sibling", :content => @sibling3.display_name)
    end

    it "should show the total completed and inspected jobs for each sibling" do
      job1 = Factory(:job)
      record = job1.job_records.build(:performer_id => @sibling1.id, :performed_on => Date.today)
      record.inspect!(@sibling2)
      job2 = Factory(:job)
      job2.job_records.build(:performer_id => @sibling1.id, :performed_on => Date.today).save!

      get :index

      response.should have_selector("span.jobsdone", :content => "2 / 1")
    end

    it "should show all daily jobs not done, when none are done" do
      job1 = Factory(:job, :interval => "daily", :sibling_id => @sibling1.id)

      get :index

      response.should have_selector("span.alldaily", :content => "NO")
    end

    it "should show all daily jobs not done, when one is uninspected" do
      job1 = Factory(:job, :interval => "daily")
      record = job1.job_records.build(:performer_id => @sibling1.id, :performed_on => Date.today)
      record.inspect!(@sibling2)
      job2 = Factory(:job, :interval => "daily")
      job2.job_records.build(:performer_id => @sibling1.id, :performed_on => Date.today).save!

      get :index

      response.should have_selector("span.alldaily", :content => "NO")
    end

    it "should show all daily jobs are done" do
      job1 = Factory(:job, :interval => "daily", :sibling_id => @sibling1.id)
      record = job1.job_records.build(:performer_id => @sibling1.id, :performed_on => Date.today)
      record.inspect!(@sibling2)

      get :index

      response.should_not have_selector("span.alldaily", :content => "NO")
    end
  end

end
