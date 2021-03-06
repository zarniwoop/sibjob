require "spec_helper"

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

    it "should show jobs with a link to job detail page" do
      job = Factory(:job)
      get :jobs, :id => @sibling
      response.should have_selector("a", :href => job_url(job.id))
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
        response.should_not have_selector("span.pointvalue", :content => job.pointvalue.to_s)
      end

      it "should show jobs designated for everyone even if one sibling has done the job" do
        other_sibling = Factory(:sibling, :email => "foo@bar.com")
        job = Factory(:job, :summary => "Clean room", :interval => "daily",
                      :assigned_to_everyone => true)
        other_sibling.perform_job!(job)
        get :jobs, :id => @sibling
        response.should have_selector("span.summary", :content => job.summary)
      end

      it "should show a job designated for everyone as done if current sibling has done the job" do
        job = Factory(:job, :summary => "Clean room", :interval => "daily",
                      :assigned_to_everyone => true)
        @sibling.perform_job!(job)
        get :jobs, :id => @sibling
        response.should have_selector("input", :value => "Undo")
        response.should_not have_selector("input", :value => "Done!")
      end

      it "should show another instance of a repeatable job even if completed by sibling" do
        job = Factory(:job, :summary => "Wash load of clothes", :interval => "repeatable")
        @sibling.perform_job!(job)
        get :jobs, :id => @sibling
        response.should have_selector("input", :value => "Undo")
        response.should have_selector("input", :value => "Done!")
      end

      it "should properly set the next appearance day for weekly recurring jobs" do
        job = Factory(:job, :summary => "Clean basement stairs", :interval => "weekly")
        date_for_job = Date.today - 3
        @sibling.perform_job!(job, date_for_job)
        get :jobs, :id => @sibling, :jobs_on_date => date_for_job.to_s
        response.should have_selector("input", :value => "Undo")
        get :jobs, :id => @sibling, :jobs_on_date => Date.today.to_s
        response.should_not have_selector("span.summary", :content => job.summary)
        get :jobs, :id => @sibling, :jobs_on_date => (Date.today + 3).to_s
        response.should_not have_selector("span.summary", :content => job.summary)
        get :jobs, :id => @sibling, :jobs_on_date => (Date.today + 4).to_s
        response.should have_selector("span.summary", :content => job.summary)
        response.should have_selector("input", :value => "Done!")
      end

      # it "should show weekly jobs designated for everyone even if one sibling has done the job"
    end

    describe "inspections" do

      before(:each) do
        @performer = Factory(:sibling, :email => "foo@bar.com")
      end

      describe "for inspectable jobs" do
        before(:each) do
          @performed_job = Factory(:job, :summary => "Sweep front porch", :interval => "weekly")
          @performer.perform_job!(@performed_job)
        end

        it "should show any jobs done by another sibling that need inspection" do
          get :jobs, :id => @sibling
          response.should have_selector("h2", :content => "Inspections Needed")
          response.should have_selector("span.summary", :content => @performed_job.summary)
        end

        it "should show inspections only on the day job was completed" do
          get :jobs, :id => @sibling, :jobs_on_date => (Date.today + 1).to_s
          response.should_not have_selector("h2", :content => "Inspections Needed")
          response.should_not have_selector("span.summary", :content => @performed_job.summary)
        end

        it "should not show sibling's own completed jobs as needing inspection" do
          get :jobs, :id => @performer
          response.should_not have_selector("h2", :content => "Inspections Needed")
        end

        it "should show an inspect button for jobs to be inspected" do
          get :jobs, :id => @sibling
          response.should have_selector("input", :value => "It's Good!")
        end

        it "should show a button to take back an inspection" do
          @sibling.inspect_job!(@performed_job.job_records[0])
          get :jobs, :id => @sibling
          response.should have_selector("input", :value => "Take Back")
        end

        it "should only show take back button for sibling who inspected the job" do
          @sibling.inspect_job!(@performed_job.job_records[0])
          other_sibling = Factory(:sibling, :email => "bigsister@example.com")
          get :jobs, :id => other_sibling
          response.should_not have_selector("input", :value => "Take Back")
        end

        it "should not show buttons for inspected jobs for the job performer" do
          get :jobs, :id => @performer
          response.should have_selector("input", :value => "Undo")
          @sibling.inspect_job!(@performed_job.job_records[0])
          get :jobs, :id => @performer
          response.should_not have_selector("input", :value => "Undo")
        end
      end

      describe "for uninspectable jobs" do
        it "should not show jobs for inspection" do
          uninspectable_job = Factory(:job, :summary => "Wash clothes", :inspectable => false)
          @performer.perform_job!(uninspectable_job)
          get :jobs, :id => @sibling
          response.should_not have_selector("h2", :content => "Inspections Needed")
          response.should_not have_selector("span.summary", :content => uninspectable_job.summary)
        end

        it "should indicate inspection not needed after completion" do
          uninspectable_job = Factory(:job, :summary => "Wash clothes", :inspectable => false)
          @performer.perform_job!(uninspectable_job)
          get :jobs, :id => @performer
          response.should have_selector("span.summary",
                                :content => "(Inspection not needed)")
        end
      end

    end
  end
end