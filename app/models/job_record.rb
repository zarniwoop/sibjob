# == Schema Information
# Schema version: 20110517212546
#
# Table name: job_records
#
#  id           :integer(4)      not null, primary key
#  job_id       :integer(4)
#  performer_id :integer(4)
#  inspector_id :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#

class JobRecord < ActiveRecord::Base
  attr_accessible :performer_id, :inspector_id

  belongs_to :job
  belongs_to :performer, :class_name => "Sibling"
  belongs_to :inspector, :class_name => "Sibling"

  validates :job_id, :presence => true
  validates :performer_id, :presence => true
end
