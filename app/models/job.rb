# == Schema Information
# Schema version: 20110602234703
#
# Table name: jobs
#
#  id                   :integer(4)      not null, primary key
#  summary              :string(255)
#  description          :text
#  pointvalue           :integer(4)
#  sibling_id           :integer(4)
#  created_at           :datetime
#  updated_at           :datetime
#  interval             :string(255)
#  assigned_to_everyone :boolean(1)
#

class Job < ActiveRecord::Base
  attr_accessible :summary, :description, :pointvalue, :assigned_to_everyone
  belongs_to :sibling
  has_many :job_records

  scope :to_do_for_sibling, lambda { |sibling, on_date| to_do_for_sibling_on_date(sibling, on_date) }
  scope :done_for_sibling, lambda { |sibling, on_date| done_for_sibling_on_date(sibling, on_date) }

  def performed_by(sibling, on_date)
     job_records.find_all_by_performer_id_and_performed_on(sibling.id, on_date)
  end

  def performed_by?(sibling, on_date)
    !self.performed_by(sibling, on_date).empty?
  end

  private

  def self.to_do_for_sibling_on_date(sibling, on_date)
    ids_for_jobs_performed_today =
       %(SELECT job_id FROM jobs, job_records
          WHERE performed_on = :on_date
            AND jobs.id = job_id
            AND assigned_to_everyone = 0
            AND (jobs.interval IS NULL OR jobs.interval <> "repeatable"))
    ids_for_weekly_jobs_performed_within_week =
        %(SELECT job_id FROM jobs, job_records
          WHERE performed_on between :on_date - INTERVAL 6 DAY and :on_date
            AND jobs.id = job_id
            AND jobs.interval = "weekly")
    where(%(id NOT IN (#{ids_for_jobs_performed_today})
          AND id NOT IN (#{ids_for_weekly_jobs_performed_within_week})
          AND (sibling_id IS NULL OR sibling_id = :sibling_id)),
          {:on_date => on_date, :sibling_id => sibling})
  end

  def self.done_for_sibling_on_date(sibling, on_date)
    joins(:job_records).where(:job_records => {:performer_id => sibling.id, :performed_on => on_date})
  end
end
