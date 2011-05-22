# == Schema Information
# Schema version: 20110517191025
#
# Table name: jobs
#
#  id          :integer(4)      not null, primary key
#  summary     :string(255)
#  description :text
#  pointvalue  :integer(4)
#  sibling_id  :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#  interval    :string(255)
#

class Job < ActiveRecord::Base
  attr_accessible :summary, :description, :pointvalue
  belongs_to :sibling
  has_many :job_records

  def self.for_sibling(sibling)
    where("sibling_id IS NULL OR sibling_id = ?", sibling)
  end

  def performed_by?(sibling)
    job_records.find_by_performer_id(sibling.id) != nil
  end
end
