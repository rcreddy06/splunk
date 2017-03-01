# Pull in default recipe so we have the forwarder installed
include_recipe 'splunk_forwarder_test::default'

# Option hash for monitor options
option_hash = { recursive: true }
# Define a splunk_monitor_instance
splunk_monitor '/var/log' do
  monitor_options option_hash
end