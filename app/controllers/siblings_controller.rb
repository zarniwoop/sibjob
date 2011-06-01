class SiblingsController < ApplicationController
  def jobs
    @sibling = Sibling.find(params[:id])
    @jobs_for_date = date_for_job_list(params)
    @jobs = @sibling.job_list
    @jobs.each do |job|
      job.interval ||= "one-time"
    end
    @job_intervals = @jobs.group_by {|job| job.interval}
  end

  private

  def date_for_job_list(params)
    date = Date.parse(params[:jobs_on_date]) unless params[:jobs_on_date].nil?
    date ||= build_date_from_params("performed_on", params[:JobRecord]) unless params[:JobRecord].nil?
    date ||= Date.today
    return date
  end
end
