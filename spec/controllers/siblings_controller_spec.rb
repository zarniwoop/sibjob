require "rspec"

describe SiblingsController do
  render_views

  describe "GET 'jobs'" do

    before(:each) do
      @sibling = Factory(:sibling)
    end

    it "should be successful" do
      get :jobs, :id => @sibling
    end

    it "should find the right sibling" do
      get :jobs, :id => @sibling
      assigns(:sibling).should == @sibling
    end

    it "should include the sibling's name" do
      get :jobs, :id => @sibling
      response.should have_selector("h1", :content => @sibling.email)
    end

    it "should show jobs for themselves and everyone" do
      job1 = Factory(:job, :sibling => @sibling, :summary => "Wash dishes", :pointvalue => 4)
      job2 = Factory(:job, :summary => "Clean room", :pointvalue => 3)
      get :jobs, :id => @sibling
      response.should have_selector("span.summary", :content => job1.summary)
      response.should have_selector("span.pointvalue", :content => job1.pointvalue.to_s)
      response.should have_selector("span.summary", :content => job2.summary)
      response.should have_selector("span.pointvalue", :content => job2.pointvalue.to_s)
    end

    it "should not show jobs for other siblings" do
      other_sibling = Factory(:sibling, :email => "foo@bar.com")
      job1 = Factory(:job, :sibling => @sibling, :summary => "Wash dishes")
      job2 = Factory(:job, :summary => "Clean room")
      get :jobs, :id => other_sibling
      response.should_not have_selector("span.summary", :content => job1.summary)
      response.should have_selector("span.summary", :content => job2.summary)
    end

    it "should group jobs by interval" do
      job1 = Factory(:job, :summary => "Wash dishes", :interval => "weekly")
      job2 = Factory(:job, :summary => "Clean room", :interval => "daily")
      get :jobs, :id => @sibling
      response.body.should =~ /Daily.*Clean room.*Weekly/m
      response.should have_selector("h2", :content => "Daily Jobs")
      response.should have_selector("h2", :content => "Weekly Jobs")
    end

    describe "job completion" do

#      it "should show a link to mark a job done if not done" do
#        job = Factory(:job, :summary => "Wash dishes")
#        get :jobs, :id => @sibling
#        response.should have_selector("a", :content => "Done!")
#      end

      it "should show a link to mark a job undone if done"

      # it "should show jobs for a specific date"
      # it "should remember jobs marked done on a specific date"
      # it "should show jobs designated for everyone even if one sibling has done the job"
      # it "should properly set the next appearance day for non-daily recurring jobs"

    end
  end
end