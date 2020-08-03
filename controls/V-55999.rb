# encoding: UTF-8

control "V-55999" do
  title "The NGINX web server must be protected from being stopped by a
non-privileged user."
  desc  "An attacker has at least two reasons to stop a web server. The first
is to cause a DoS, and the second is to put in place changes the attacker made
to the web server configuration.

    To prohibit an attacker from stopping the web server, the process ID (pid)
of the web server and the utilities used to start/stop the web server must be
protected from access by non-privileged users. By knowing the pid and having
access to the web server utilities, a non-privileged user has a greater
capability of stopping the server, whether intentionally or unintentionally.
  "
  
  desc  "check", "Review the NGINX web server documentation and deployed 
  configuration to determine where the process ID is stored and which utilities 
  are used to start/stop the web server.

  Determine where the 'nginx.pid' file is located by running the following command:

    # find / -name 'nginx.pid'
  
  This file is automatically generated upon service start. Verify the file owner/group 
  is of an administrative service account:
  
    # ls -lah <'nginx.pid location'>/nginx.pid
  
  If the file owner/group is not an administrative service account, this is a finding.
  
  Verify the service utilities used to manage the NGINX service owner/group is of an 
  administrative service account.
  
    # ls -lah /usr/sbin/service
    # ls -lah /usr/sbin/nginx 
  
  If the service utilities owner/group is not an administrative service account, 
  this is a finding.
  
  Determine whether the process ID and the utilities are protected from non-privileged 
  users.
  
  If the process ID and the utilities are not protected from non-privileged users, 
  this is a finding.
  "
  desc  "fix", "Review the web server documentation and deployed configuration to 
  determine where the process ID is stored and which utilities are used to start/stop 
  the web server.

  Determine where the 'nginx.pid' file is located by running the following command:
  
    # find / -name 'nginx.pid'
  
  Run the following commands:
   
    # cd <'nginx.pid location'>/
    # chown <'service account'> nginx.pid 
    # chmod 644 nginx.pid 
    # cd /usr/sbin 
    # chown <'service account'> service nginx 
    # chmod 550 service nginx"
  impact 0.5
  tag "severity": "medium"
  tag "gtitle": "SRG-APP-000435-WSR-000147"
  tag "gid": "V-55999"
  tag "rid": "SV-70253r2_rule"
  tag "stig_id": "SRG-APP-000435-WSR-000147"
  tag "fix_id": "F-60877r1_fix"
  tag "cci": ["CCI-002385"]
  tag "nist": ["SC-5", "Rev_4"]

  if nginx_conf.params['pid'].nil?
    impact 0.0
    describe 'This check is NA because NGINX is not currently running.' do
      skip 'This check is NA because NGINX is not currently running.'
    end
  else 
    describe file(nginx_conf.params['pid'].join) do
      it { should exist }
      its('owner') { should be_in input('sys_admin').clone << input('nginx_owner')}
      its('group') { should be_in input('sys_admin_group').clone << input('nginx_group') }
      it { should_not be_more_permissive_than('0644') }
    end 
    describe file('/usr/sbin/nginx') do
      it { should exist }
      its('owner') { should be_in input('sys_admin').clone << input('nginx_owner') }
      its('group') { should be_in input('sys_admin_group').clone << input('nginx_group') }
      it { should_not be_more_permissive_than('0550') }
    end
    describe file('/usr/sbin/service') do
      it { should exist }
      its('owner') { should be_in input('sys_admin').clone << input('nginx_owner') }
      its('group') { should be_in input('sys_admin_group').clone << input('nginx_group') }
      it { should_not be_more_permissive_than('0550') }
    end 
  end 
end

