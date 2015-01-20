# == Schema Information
#
# Table name: settings
#
#  id                  :integer          not null, primary key
#  sfdc_app_id         :string(255)
#  sfdc_app_secret     :string(255)
#  insights_app_id     :string(255)
#  insights_api_key    :string(255)
#  insights_event_name :string(255)
#  polling_interval    :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#

require 'test_helper'

class SettingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
