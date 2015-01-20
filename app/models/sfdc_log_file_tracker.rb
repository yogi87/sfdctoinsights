# == Schema Information
#
# Table name: sfdc_log_file_trackers
#
#  id            :integer          not null, primary key
#  log_file_id   :string(255)
#  log_date      :datetime
#  log_file_type :string(255)
#  file_complete :boolean
#  user_id       :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class SfdcLogFileTracker < ActiveRecord::Base
end
