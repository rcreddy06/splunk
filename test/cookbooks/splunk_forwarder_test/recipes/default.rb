# Define a splunk_forwarder_instance

splunk_forwarder 'splunkforwarder' do
  tarball_name 'splunkforwarder-6.5.2-67571ef4b87d-Linux-x86_64.tgz'
  tarball_uri 'https://download.splunk.com/products/universalforwarder/releases/6.5.2/linux/splunkforwarder-6.5.2-67571ef4b87d-Linux-x86_64.tgz'
  splunk_user 'test_user'
  splunk_group 'test_group'
  action :install
end