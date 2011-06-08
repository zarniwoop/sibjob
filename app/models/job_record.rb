# == Schema Information
# Schema version: 20110523040914
#
# Table name: job_records
#
#  id           :integer(4)      not null, primary key
#  job_id       :integer(4)
#  performer_id :integer(4)
#  inspector_id :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#  performed_on :date
#

class JobRecord < ActiveRecord::Base
  attr_accessible :performer_id, :inspector_id, :performed_on

  belongs_to :job
  belongs_to :performer, :class_name => "Sibling"
  belongs_to :inspector, :class_name => "Sibling"

  validates :job_id, :presence => true
  validates :performer_id, :presence => true
  validates :performed_on, :presence => true

  after_initialize :init

  scope :done_for_sibling, lambda { |sibling, on_date| done_for_sibling_on_date(sibling, on_date) }
  scope :inspectable_for_sibling, lambda { |sibling, on_date| inspectable_for_sibling_on_date(sibling, on_date) }


  def init
    self.performed_on ||= Date.today
  end

  def inspected?
    !inspector_id.nil?
  end

  def uninspect!
    self.inspector_id = nil
    save!
  end

  private

  def self.inspectable_for_sibling_on_date(sibling, on_date)
    joins(:job).where(%(job_records.performed_on = :on_date
                     AND job_records.performer_id <> :sibling_id
                     AND jobs.inspectable = 1),
                       {:on_date => on_date, :sibling_id => sibling.id})
  end

  def self.done_for_sibling_on_date(sibling, on_date)
    where(:performer_id => sibling.id, :performed_on => on_date)
  end
end
