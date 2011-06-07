class JobRecordsController < ApplicationController
  before_filter :authenticate_sibling!

  def create
    @job = Job.find(params[:job_record][:job_id])
    date_for_job = params[:job_record][:performed_on].nil? ? Date.today : Date.parse(params[:job_record][:performed_on])
    current_sibling.perform_job!(@job, date_for_job)
    redirect_to jobs_sibling_path(current_sibling, :jobs_on_date => date_for_job)
  end

  def destroy
    @job_record = JobRecord.find(params[:id])
    date_for_job = @job_record.performed_on
    @job_record.destroy
    redirect_to jobs_sibling_path(current_sibling, :jobs_on_date => date_for_job)
  end

  def update
    @job_record = JobRecord.find(params[:id])
    current_sibling.inspect_job!(@job_record)
    redirect_to jobs_sibling_path(current_sibling, :jobs_on_date => @job_record.performed_on)
  end

end
