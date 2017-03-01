# Pull in default recipe so we have the forwarder installed
include_recipe 'splunk_forwarder_test::default'

# ensure that the splunk service resource is available without cloning
# the resource (CHEF-3694).
begin
  resources('service[splunk]')
rescue Chef::Exceptions::ResourceNotFound
  service 'splunk'
end

# Option hash for monitor options
file_option_hash = { recursive: true }
# Define a file/directory splunk_monitor instance
splunk_monitor '/var/log' do
  monitor_options file_option_hash
end

# Define a TCP splunk_monitor instance
tcp_option_hash = { listenOnIPv6: 'no', queueSize: '1MB' }

splunk_monitor ':5514' do
  monitor_type 'tcp'
  monitor_options tcp_option_hash
end

# Define a TCP splunk_monitor instance
splunktcp_option_hash = { sourcetype: 'syslog' }

splunk_monitor '10.2.0.1:9996' do
  monitor_type 'splunktcp'
  monitor_options splunktcp_option_hash
end

# Define a WinEventLog splunk_monitor instance
# This just tests that the stanza is built properly
# Only use this monitor type on Windows systems
winevent_option_hash = { start_from: 'newest',
                         disabled: 0,
                         index: 'winevents',
                         blacklist1: '4656,4658' }

splunk_monitor 'Security' do
  monitor_type 'winevent'
  monitor_options winevent_option_hash
end