class CreatePollingStatuses < ActiveRecord::Migration
  def change
    create_table :polling_statuses do |t|
      t.boolean  :currently_polling
      t.integer  :user_id
      t.timestamps
    end
  end
end
