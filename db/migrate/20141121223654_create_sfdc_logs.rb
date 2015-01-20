class CreateSfdcLogs < ActiveRecord::Migration
  def change
    create_table :sfdc_logs do |t|
      t.string   :event_type
      t.string   :log_date
      t.string   :file_id
      t.boolean  :sent_to_insights, :default => false
      t.integer  :user_id
      t.timestamps
    end
  end
end
