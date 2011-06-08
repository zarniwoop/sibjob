require 'spec_helper'

describe JobRecordsController do
  render_views

  describe "access control" do

    it "should require signin for create" do
      post :create
      response.should be_redirect
    end

    it "should require signin for destroy" do
      delete :destroy, :id => 1
      response.should be_redirect
    end
  end

  describe "POST 'create'" do

    before(:each) do
      @job = Factory(:job)
      @performer = Factory(:sibling, :email => Factory.next(:email))
      sign_in @performer
    end

    it "should create a job record" do
      lambda do
        post :create, :job_record => { :job_id => @job }
        response.should be_redirect
      end.should change(JobRecord, :count).by(1)
    end

  end

  describe "DELETE 'destroy'" do

    before(:each) do
      @job = Factory(:job)
      @performer = Factory(:sibling, :email => Factory.next(:email))
      sign_in @performer
      @performer.perform_job!(@job)
      @job_record = @job.job_records.find_by_performer_id(@performer.id)
    end

    it "should destroy a job record" do
      lambda do
        delete :destroy, :id => @job_record
      end.should change(JobRecord, :count).by(-1)
    end

    it "should redirect to the job list page" do
      lambda do
        delete :destroy, :id => @job_record
        response.should redirect_to(jobs_sibling_path(@performer,
                                                      :jobs_on_date => @job_record.performed_on))
      end
    end
  end

  describe "POST 'update'" do

    before(:each) do
      @job = Factory(:job, :interval => "daily")
      @performer = Factory(:sibling, :email => Factory.next(:email))
      @performer.perform_job!(@job)
      @job_record = @job.job_records.find_by_performer_id(@performer.id)
      @inspector = Factory(:sibling)
      sign_in @inspector
    end

    it "should inspect jobs that aren't inspected" do
      put :update, :id => @job_record
      @job_record.reload
      @job_record.inspector.should == @inspector
    end

    it "should un-inspect jobs that are previously inspected" do
      @job_record.inspector = @inspector
      @job_record.save!
      put :update, :id => @job_record
      @job_record.reload
      @job_record.inspector.should be_nil
    end

    it "should redirect to the job list page" do
      put :update, :id => @job_record, :inspector_id => @inspector
      response.should redirect_to(jobs_sibling_path(@inspector,
                                                    :jobs_on_date => @job_record.performed_on))
    end

    # it "should not allow a performer to also be the inspector"
  end

end
