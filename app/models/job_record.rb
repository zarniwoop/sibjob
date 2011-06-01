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

  def init
    self.performed_on ||= Date.today
  end
end
