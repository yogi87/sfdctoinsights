# == Schema Information
#
# Table name: polling_statuses
#
#  id                :integer          not null, primary key
#  currently_polling :boolean
#  user_id           :integer
#  created_at        :datetime
#  updated_at        :datetime
#

require 'test_helper'

class PollingStatusTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
