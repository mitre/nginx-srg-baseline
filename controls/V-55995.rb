# encoding: UTF-8

control "V-55995" do
  title "NGINX web server accounts accessing the directory tree, the shell, or other
operating system functions and utilities must only be administrative accounts."
  desc  "As a rule, accounts on a web server are to be kept to a minimum. Only
administrators, web managers, developers, auditors, and web authors require
accounts on the machine hosting the web server. The resources to which these
accounts have access must also be closely monitored and controlled. Only the
system administrator needs access to all the system's capabilities, while the
web administrator and associated staff require access and control of the web
content and web server configuration files."
  
  desc  "check", "Review the NGINX web server documentation and configuration to 
  determine what web server accounts are available on the hosting server.

  Obtain a list of the user accounts for the system, noting the priviledges for 
  each account.

  Verify with the system administrator or the ISSO that all privileged accounts are 
  mission essential and documented.

  Verify with the system administrator or the ISSO that all non-administrator access 
  to shell scripts and operating system functions are mission essential and documented.

  If undocumented privileged accounts are found, this is a finding.

  If undocumented access to shell scripts or operating system functions is found, 
  this is a finding.
  "
  desc  "fix", "Ensure non-administrators are not allowed access to thedirectory tree, 
  the shell, or other operating system functions and utilities."

  impact 0.5
  tag "severity": "medium"
  tag "gtitle": "SRG-APP-000211-WSR-000030"
  tag "gid": "V-55995"
  tag "rid": "SV-70249r2_rule"
  tag "stig_id": "SRG-APP-000211-WSR-000030"
  tag "fix_id": "F-60873r1_fix"
  tag "cci": ["CCI-001082"]
  tag "nist": ["SC-2", "Rev_4"]

  authorized_sa_user_list = input('sys_admin').clone << input('nginx_owner')

  describe "Unauthorized users" do
    it "should not have shell access." do
      expect(users.shells(/bash/).usernames).to(be_in authorized_sa_user_list)
    end
  end

  if users.shells(/bash/).usernames.empty?
    describe "Skip Message" do
      skip "Skipped: no users found with shell acccess."
    end
  end
end

