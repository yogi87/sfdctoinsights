require 'poller'
class HomeController < ApplicationController
  include Poller

  @setting = Setting.first

  def index
    if current_user
      @files_sent_to_insights = SfdcLogFileTracker.all.limit(20).order("updated_at DESC")
    end
  end

  def start_polling
    if current_user
      client = Restforce.new :oauth_token => current_user.oauth_token,
        :refresh_token => current_user.refresh_token,
        :instance_url  => current_user.instance_url,
        :client_id     => Setting.first.sfdc_app_id,
        :client_secret => Setting.first.sfdc_app_secret
        begin
         ps = PollingStatus.first_or_create
         ps.update_attributes(currently_polling:true)
         SfdcLog.delay.fetch_files_from_sfdc(client)
        flash[:notice] = 'Polling Started'
        rescue
         flash[:error] = 'Issue connecting to SFDC API. Please try again later.'
        end
        redirect_to :back
    end
  end


  def stop_polling
    if current_user
    ps = PollingStatus.first_or_create
    ps.update_attributes(currently_polling:false)
    flash[:error] = 'Polling Stopped'
    redirect_to :back
    end
  end

end
