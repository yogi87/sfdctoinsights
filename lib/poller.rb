require 'faraday'
require 'csv'
require 'json'

module Poller


    def self.do_something(client)
      loop do 
       return client.inspect
       break if PollingStatus.where(user_id:1).first_or_create.currently_polling = false
      end
    end
    #method called from home_controller to get files
    def self.fetch_files_from_sfdc(client)
      get_available_files(client)
    end

    #create list of file meta + endpoints
    def self.get_available_files(client)
    #set appropriate timeframe. 
    date = "Last_n_Days:2"
    l = client.get "/services/data/v32.0/query?q=Select+Id+,+EventType+,+LogFile+,+LogDate+From+EventLogFile+Where+LogDate+=+#{date}"
    #create hash to store info needed to download and save files
    file_information = {}
    l.body.each do |a|
      file_information["#{a.EventType}_#{a.LogDate}_#{a.Id}"] = a.LogFile
    end
    #send files to data to download_log_files to download
    check_diff_in_files(file_information, client)
    end

    def self.check_diff_in_files(file_information, client)
      new_file_to_download = []
      file_information.each do |log_type, endpoint|
        event_type  = log_type.split("_")[0]
        log_date    = log_type.split("_")[1]
        file_id     = log_type.split("_")[2]
        new_file_to_download << file_id
      end
      unless [SfdcLog.all.to_a.map{|x| x.file_id} - new_file_to_download].flatten.empty?
        download_log_files(file_information, client)
      end
    end

    def self.files_to_send(file_information)
      file_information.each do |log_type, endpoint|
        event_type  = log_type.split("_")[0]
        log_date    = log_type.split("_")[1]
        file_id     = log_type.split("_")[2]
        rec_previously_sent = SfdcLogFileTracker.where(:log_file_type => event_type, :log_date => log_date, :log_file_id => file_id)
        unless rec_previously_sent.exists?
          file = Rails.root.join("lib", "raw_sfdc_log_files", "#{log_type}.csv")
          status_return = send_to_insights(file)
          status_return = 200 ? file_sent = true : file_sent = false
          SfdcLogFileTracker.where(:log_file_type => event_type, :log_date => log_date, :log_file_id => file_id, :file_complete => file_sent).create
          FileUtils.rm(file)
        end 
      end
    end

    #request and download all available files to sfdc_insights/lib/sfdc_log_files
    def self.download_log_files(file_information, client)
      file_information.each do |log_type, endpoint|
        response    = client.get endpoint
        event_type  = log_type.split("_")[0]
        log_date    = log_type.split("_")[1]
        file_id     = log_type.split("_")[2]
        file = SfdcLog.where(:event_type => event_type, :log_date => log_date, :file_id => file_id)
        unless file.exists?
        File.open(Rails.root.join("lib", "raw_sfdc_log_files", "#{log_type}.csv"), 'w') { |file| file.write(response.body) }
        SfdcLog.where(:event_type => event_type, :log_date => log_date, :file_id => file_id).create
        end
      end
      files_to_send(file_information)
    end

    def self.convert_time(sfdc_timestamp)
      raw_timestamp = sfdc_timestamp
      year              = raw_timestamp.split(".").first.split("")[0..3]
      month             = raw_timestamp.split(".").first.split("")[4..5]
      date              = raw_timestamp.split(".").first.split("")[6..7]
      hour              = raw_timestamp.split(".").first.split("")[8..9]
      min               = raw_timestamp.split(".").first.split("")[10..11]
      second            = raw_timestamp.split(".").first.split("")[12..13]
      comp_timestamp    = "#{year.join}-#{month.join}-#{date.join} #{hour.join}:#{min.join}:#{second.join}"
      formatted_time    = Time.zone.parse(comp_timestamp).utc
      return formatted_time
    end
    #change stings to ints. 
    def self.csv_to_array(file_name)
      puts file_name
      data_array = []
      puts "Starting parsing file: #{file_name}"
      CSV.foreach(file_name, :headers => true) do |row|
        data_hash = row.to_hash
        data_hash["eventType"] = "SFDC_LogFileEvent"
        data_hash["SFDC_eventType"] = data_hash.delete "EVENT_TYPE"
        data_hash["timestamp"] = data_hash.delete "TIMESTAMP"
        new_timestamp = {"timestamp" => convert_time(data_hash["timestamp"]).to_i}
        data_hash.update(new_timestamp)
        data_array.push(data_hash)
      end
      puts "Done parsing file: #{file_name}"
      return data_array
    end

    def self.send_to_insights(file_name)
        data = csv_to_array(file_name)
        if data.count < 995
          payload = data.to_json
            conn = Faraday.new(:url => 'https://insights-collector.newrelic.com') do |faraday|
            faraday.request  :json           # form-encode POST params
            #faraday.response :logger         # log requests to STDOUT
            faraday.adapter  :net_http 
            end
            response = conn.post "/v1/accounts/#{Rails.application.config.insights_app_id}/events", payload, 'Content-Type' => 'application/json', 'X-Insert-Key' => Rails.application.config.insights_api_key
            puts "*****Response = #{response.body}*****"
            return response.status
          else
            data.each_slice(995) do |segment|
            payload = segment.to_json
              conn = Faraday.new(:url => 'https://insights-collector.newrelic.com') do |faraday|
              faraday.request  :json           # form-encode POST params
              #faraday.response :logger         # log requests to STDOUT
              faraday.adapter  :net_http 
              end
            end
            response = conn.post "/v1/accounts/#{Rails.application.config.insights_app_id}/events", payload, 'Content-Type' => 'application/json', 'X-Insert-Key' => Rails.application.config.insights_api_key
            puts "*****Response = #{response.body}*****" 
            return response.status      
        end 
    end

end



