# Define a splunk_server_instance

splunk_server 'splunkserver' do
  tarball_name 'splunk-6.5.2-67571ef4b87d-Linux-x86_64.tgz'
  tarball_uri 'https://download.splunk.com/products/splunk/releases/6.5.2/linux/splunk-6.5.2-67571ef4b87d-Linux-x86_64.tgz'
  splunk_user 'test_user'
  splunk_group 'test_group'
  action :install
end