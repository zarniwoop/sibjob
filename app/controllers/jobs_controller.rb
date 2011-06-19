class JobsController < ApplicationController

  def show
    @job = Job.find(params[:id])
    @assignee = @job.sibling.display_name unless @job.sibling.nil?
    @assignee ||= @job.assigned_to_everyone ? "Everyone" : nil
  end

end
