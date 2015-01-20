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

class PollingStatus < ActiveRecord::Base
end
