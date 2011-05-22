class SiblingsController < ApplicationController
  def jobs
    @sibling = Sibling.find(params[:id])
    @jobs = @sibling.job_list
    @jobs.each do |job|
      job.interval ||= "one-time"
    end
    @job_intervals = @jobs.group_by {|job| job.interval}
  end
end
