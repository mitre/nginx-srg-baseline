# encoding: UTF-8


control "V-41668" do
  title "The NGINX web server must use the internal system clock to generate time
  stamps for log records."
  desc  "Without an internal clock used as the reference for the time stored on
  each event to provide a trusted common reference for the time, forensic
  analysis would be impeded. Determining the correct time a particular event
  occurred on the web server is critical when conducting forensic analysis and
  investigating system events.

    If the internal clock is not used, the web server may not be able to
  provide time stamps for log messages. The web server can use the capability of
  an operating system or purpose-built module for this purpose.

    Time stamps generated by the web server shall include both date and time.
  The time may be expressed in Coordinated Universal Time (UTC), a modern
  continuation of Greenwich Mean Time (GMT), or local time with an offset from
  UTC.
  "
  desc  "check", "Review the NGINX web server documentation and deployment 
  configuration to determine if the internal system clock is used for date and 
  time stamps. If this is not feasible, an alternative workaround is to take an 
  action that generates an entry in the log and then immediately query the operating system
  for the current time. A reasonable match between the two times will suffice as
  evidence that the system is using the internal clock for date and time stamps.

  Check for the following:
      # grep for a 'log_format' directive in the http context of the nginx.conf.

  If the 'log_format' directive is not configured to contain the '$time_local' 
  variable, this is a finding. 
  "
  desc  "fix", "
  Configure the 'log_format' directive in the nginx.conf to use the '$time_local' 
  variable to use internal system clocks to generate date and time stamps for 
  log records."

  impact 0.5
  tag "severity": "medium"
  tag "gtitle": "SRG-APP-000116-WSR-000066"
  tag "gid": "V-41668"
  tag "rid": "SV-54245r3_rule"
  tag "stig_id": "SRG-APP-000116-WSR-000066"
  tag "fix_id": "F-47127r2_fix"
  tag "cci": ["CCI-000159"]
  tag "nist": ["AU-8 a", "Rev_4"]

  if nginx_conf.params['http'].nil?
    impact 0.0
    describe 'This check is NA because no websites have been configured.' do
      skip 'This check is NA because no websites have been configured.'
    end
  else
    nginx_conf.params['http'].each do |http|
      http["log_format"].each do |log_format|
        describe 'time_local' do
          it 'should be part of every log format in http.' do
            expect(log_format.to_s).to(match /.*?\$time_local.*?/)
          end
        end
      end
    end
  end
end

