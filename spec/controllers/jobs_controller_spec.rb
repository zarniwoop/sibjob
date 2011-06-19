require 'spec_helper'

describe JobsController do
  render_views

  before(:each) do
    @assignee = Factory(:sibling)
    @job = Factory(:job, :summary => "This is the job summary",
      :description => "This is the job description", :interval => "weekly",
      :pointvalue => 5, :inspectable => false, :assigned_to_everyone => false,
      :sibling_id => @assignee.id)
  end

  describe "get 'show'" do
    it "should have a working 'show' page" do
      get :show, :id => @job
    end

    it "should be successful" do
      get :show, :id => @job
      response.should have_selector("span.summary", :content => "This is the job summary")
    end

    it "should show the job interval" do
      get :show, :id => @job
      response.should have_selector("span.interval", :content => "(weekly)")
    end

    it "should show the job description" do
      get :show, :id => @job
      response.should have_selector("span.description", :content => "This is the job description")
    end

    it "should show the job point value" do
      get :show, :id => @job
      response.should have_selector("span.pointvalue", :content => "5")
    end

    it "should show the job assignee" do
      get :show, :id => @job
      response.should have_selector("span.assignee", :content => @assignee.display_name)
    end

    it "should show the job inspectable state" do
      get :show, :id => @job
      response.should have_selector("span.inspectable", :content => "No")
    end

    it "should show the job assigned to everyone state" do
      job_for_everyone = Factory(:job, :assigned_to_everyone => true)
      get :show, :id => job_for_everyone
      response.should have_selector("span.assignee", :content => "Everyone")
    end

    it "should not show assignee if no sibling assigned" do
      job_unassigned = Factory(:job)
      get :show, :id => job_unassigned
      response.should_not have_selector("span.assignee")
    end
  end

end
