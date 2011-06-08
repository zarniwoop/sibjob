# == Schema Information
# Schema version: 20110514224259
#
# Table name: siblings
#
#  id                     :integer(4)      not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(128)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer(4)      default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#

class Sibling < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :job
  has_many :job_records, :foreign_key => "performer_id"
  has_many :job_records, :foreign_key => "inspector_id"

  def job_list(performed_on_date = nil)
    performed_on_date ||= Date.today
    Job.for_sibling(self, performed_on_date)
  end

  def perform_job!(job, performed_on_date = nil)
    performed_on_date ||= Date.today
    job.job_records.build(:performer_id => self.id, :performed_on => performed_on_date)
    job.save!
  end

  def remove_job!(job_record)
    job_record.destroy!
  end

  def inspect_job!(job_record)
    job_record.inspect!(self)
  end

end
