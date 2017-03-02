#[monitor:///var/log]
#[tcp://:9997]
#[splunktcp://10.1.1.100:9996]
#[splunktcp-ssl:9996]
#[fschange:/etc/]
#[WinEventLog://Security]
#[perfmon://LocalPhysicalDisk]
#[admon://DefaultTargetDC]

resource_name :splunk_monitor

property :path, String, name_property: true
property :monitor_type, String, default: "file" # %w(file fschange winevent tcp splunktcp admon perfmon)
property :monitor_options, Hash, default: {} #hash of monitor options { sourcetype: "access_combined", disabled: 0 }

default_action :install

action_class do

  # replace all forward slashes, period, or colons with underscores
  def clean_dir_name(path)
    path.gsub(/[\/\.\:]/, '_')
  end

  def app_path
    return "/opt/splunkforwarder/etc/apps/00_autogen_inputs_#{clean_dir_name(new_resource.path)}/local"
  end
end

action :install do
  directory 'splunk monitor dir' do
    mode '0755'
    path app_path
    recursive true
    owner ::File.stat("/opt/splunkforwarder/license-eula.txt").uid
    group ::File.stat("/opt/splunkforwarder/license-eula.txt").gid
  end

  template "#{app_path}/inputs.conf" do
    source 'monitor/inputs.conf.erb'
    owner ::File.stat("/opt/splunkforwarder/license-eula.txt").uid
    group ::File.stat("/opt/splunkforwarder/license-eula.txt").gid
    variables(
      :path => new_resource.path,
      :type => new_resource.monitor_type,
      :options => new_resource.monitor_options
    )
    notifies :restart, 'service[splunk]', :delayed
  end 
end