class CreateSfdcLogFileTrackers < ActiveRecord::Migration
  def change
    create_table :sfdc_log_file_trackers do |t|
      t.string   :log_file_id
      t.datetime :log_date
      t.string   :log_file_type
      t.boolean  :file_complete
      t.integer  :user_id
      t.timestamps
    end
  end
end
