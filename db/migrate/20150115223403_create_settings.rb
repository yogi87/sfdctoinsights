class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :sfdc_app_id
      t.string :sfdc_app_secret
      t.string :insights_app_id
      t.string :insights_api_key
      t.string :insights_event_name
      t.string :polling_interval

      t.timestamps
    end
  end
end
