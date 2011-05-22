class JobRecordsController < ApplicationController
  before_filter :authenticate_sibling!

  def create
    @job = Job.find(params[:job_record][:job_id])
    current_sibling.perform_job!(@job)
    redirect_to jobs_sibling_path(current_sibling)
  end

  def destroy
    @job_record = JobRecord.find(params[:id])
    @job_record.destroy
    redirect_to jobs_sibling_path(current_sibling)
  end

  def update
  end

end
