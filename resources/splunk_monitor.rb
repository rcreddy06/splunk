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