# == Schema Information
#
# Table name: sfdc_logs
#
#  id               :integer          not null, primary key
#  event_type       :string(255)
#  log_date         :string(255)
#  file_id          :string(255)
#  sent_to_insights :boolean          default(FALSE)
#  user_id          :integer
#  created_at       :datetime
#  updated_at       :datetime
#

require 'test_helper'

class SfdcLogTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
