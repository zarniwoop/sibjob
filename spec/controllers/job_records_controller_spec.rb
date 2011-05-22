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

#    it "should create a relationship using Ajax" do
#      lambda do
#        xhr :post, :create, :relationship => { :followed_id => @followed }
#        response.should be_success
#      end.should change(Relationship, :count).by(1)
#    end
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
        response.should be_redirect
      end.should change(JobRecord, :count).by(-1)
    end

#    it "should destroy a relationship using Ajax" do
#      lambda do
#        xhr :delete, :destroy, :id => @relationship
#        response.should be_success
#      end.should change(Relationship, :count).by(-1)
#    end
  end

#  describe "GET 'update'" do
#    it "should be successful" do
#      put 'update', :id => 1
#      response.should be_success
#    end
#  end

end
