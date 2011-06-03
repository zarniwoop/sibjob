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

  scope :for_sibling, lambda { |sibling, on_date| for_sibling_on_date(sibling, on_date) }

  def performed_by?(sibling, on_date)
    job_records.find_by_performer_id_and_performed_on(sibling.id, on_date) != nil
  end

  private

  def self.for_sibling_on_date(sibling, on_date)
    ids_for_jobs_performed_today_by_others =
                       %(SELECT job_id FROM jobs, job_records
                          WHERE performed_on = :on_date
                            AND jobs.id = job_id
                            AND assigned_to_everyone = 0
                            AND performer_id <> :sibling_id)
    where(%(id NOT IN (#{ids_for_jobs_performed_today_by_others}) 
          AND (sibling_id IS NULL OR sibling_id = :sibling_id)),
          {:on_date => on_date, :sibling_id => sibling})
  end
end
