# Pull in default recipe so we have the forwarder installed
include_recipe 'splunk_forwarder_test::default'

# Define a splunk_monitor_instance
splunk_monitor '/var/log'