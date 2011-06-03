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

    describe "job day selector" do
      it "should be present" do
        job = Factory(:job, :summary => "Wash dishes")
        get :jobs, :id => @sibling
        response.should have_selector("form", :action =>"/siblings/#{@sibling.id}/jobs")
        response.should have_selector("select", :name => "JobRecord[performed_on(1i)]")
        response.should have_selector("select", :name => "JobRecord[performed_on(2i)]")
        response.should have_selector("select", :name => "JobRecord[performed_on(3i)]")
        response.should have_selector("input", :type => "submit", :value => "Go")
      end

      it "should show day passed in" do
        date_to_show = Date.today - 2
        get :jobs, :id => @sibling, :jobs_on_date => date_to_show.to_s
        response.should have_selector("option", :selected => "selected",
                                      :value => date_to_show.year.to_s)
        response.should have_selector("option", :selected => "selected",
                                      :value => date_to_show.day.to_s)
        response.should have_selector("option", :selected => "selected",
                                      :value => date_to_show.month.to_s)
      end
    end

    describe "job completion" do

      it "should show a button to mark a job done if not done" do
        job = Factory(:job, :summary => "Wash dishes")
        get :jobs, :id => @sibling
        response.should have_selector("input", :value => "Done!")
      end

      it "should have a hidden field to mark a job done on a specific date" do
        job = Factory(:job, :summary => "Wash dishes")
        date_for_job = Date.today - 3
        get :jobs, :id => @sibling, :jobs_on_date => date_for_job.to_s
        response.should have_selector("input", :type => "hidden", :id => "job_record_performed_on",
                                      :value => date_for_job.to_s)
      end

      it "should show a link to mark a job undone if done" do
        job = Factory(:job, :summary => "Wash dishes")
        @sibling.perform_job!(job)
        get :jobs, :id => @sibling
        response.should have_selector("input", :value => "Undo")
      end

      it "should remember jobs marked done on a specific date" do
        job = Factory(:job, :summary => "Wash dishes")
        date_for_job = Date.today - 3
        @sibling.perform_job!(job, date_for_job)
        get :jobs, :id => @sibling, :jobs_on_date => date_for_job.to_s
        response.should have_selector("input", :value => "Undo")
        get :jobs, :id => @sibling, :jobs_on_date => Date.today.to_s
        response.should have_selector("input", :value => "Done!")
      end

      it "should not show jobs completed on a day by one sibling for another sibling" do
        other_sibling = Factory(:sibling, :email => "foo@bar.com")
        job = Factory(:job, :summary => "Sweep front porch", :interval => "weekly")
        other_sibling.perform_job!(job)
        get :jobs, :id => @sibling
        response.should_not have_selector("span.summary", :content => job.summary)
      end

      it "should show jobs designated for everyone even if one sibling has done the job" do
        other_sibling = Factory(:sibling, :email => "foo@bar.com")
        job = Factory(:job, :summary => "Sweep front porch", :interval => "weekly",
                      :assigned_to_everyone => true)
        other_sibling.perform_job!(job)
        get :jobs, :id => @sibling
        response.should have_selector("span.summary", :content => job.summary)
      end

      # it "should properly set the next appearance day for non-daily recurring jobs"

    end

    describe "inspections" do

      # it "should show any job that has been completed by another sibling but not inspected"
      # it "should show inspections on the same day job was completed"
      # it "should not show sibling's own completed jobs as needing inspection"
      # it "should not show buttons for inspected jobs for the job performer"
      # it "should not allow an already-inspected job to be marked inspected"
      # it "should allow an inspector to retract an inspection"

    end
  end
end