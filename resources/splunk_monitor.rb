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

action_class do

  # replace all forward slashes, period, or colons with underscores
  def clean_dir_name(path)
    path.gsub(/[\/\.\:]/, '_')
  end

  def app_path
    return "/opt/splunkforwarder/etc/apps/00_autogen_inputs_#{clean_dir_name(new_resource.path)}/local"
  end

  def monitor_config
    case monitor_type
    when 'file'
      return "[monitor://#{new_resource.path}]\n"
    when 'winevent'

    when 'tcp'

    else
      Chef::Log.fatal("You have set an incorrect monitor type for '#{new_resource.path}'")
      raise "Failed to setup splunk monitor '#{new_resource.path}'"
    end
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

  file "#{app_path}/inputs.conf" do
    content monitor_config
  end
end