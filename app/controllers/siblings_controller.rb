class SiblingsController < ApplicationController
  def jobs
    @sibling = Sibling.find(params[:id])
    @jobs_for_date = date_for_job_list(params)
    @jobs_to_do = Job.to_do_for_sibling(@sibling, @jobs_for_date)
    @jobs_to_do.each do |job|
      job.interval ||= "one-time"
    end
    @job_intervals = @jobs_to_do.group_by {|job| job.interval}
    @jobs_done = Job.done_for_sibling(@sibling, @jobs_for_date)
    @job_records_to_inspect = JobRecord.inspectable_for_sibling(@sibling, @jobs_for_date)
  end

  private

  def date_for_job_list(params)
    date = Date.parse(params[:jobs_on_date]) unless params[:jobs_on_date].nil?
    date ||= build_date_from_params("performed_on", params[:JobRecord]) unless params[:JobRecord].nil?
    date ||= Date.today
    return date
  end
end
