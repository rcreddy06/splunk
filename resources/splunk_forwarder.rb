resource_name :splunk_forwarder

property :install_path, String, default: "/opt/splunkforwarder"
# tarball name and uri will need to be updated for every new release since Splunk can't 
# seem to just provide a standard uri schemed for pulling these.
property :tarball_name, String, default: 'splunkforwarder-6.5.2-67571ef4b87d-Linux-x86_64.tgz'
property :tarball_uri, String, default: lazy { |r| "https://download.splunk.com/products/universalforwarder/releases/6.5.2/linux/#{r.tarball_name}" }
property :checksum_uri, String, default: lazy { |r| "#{r.tarball_uri}.md5" }
property :splunk_user, String, default: 'splunk'
property :splunk_group, String, default: 'splunk'

action_class do

  def extraction_command
    cmd = "tar -xzopf #{Chef::Config['file_cache_path']}/#{new_resource.tarball_name} -C #{new_resource.install_path} --strip 1"
  end

  # validate the mirror checksum against the on disk checksum
  # return true if they match. Append .bad to the cached copy to prevent using it next time
  def validate_checksum(file_to_check)
    # desired = fetch_checksum
    desired = ::File.read("#{Chef::Config['file_cache_path']}/#{new_resource.tarball_name}.md5").split.last
    actual = Digest::MD5.hexdigest(::File.read(file_to_check))

    if desired == actual
      true
    else
      Chef::Log.fatal("The checksum of the splunk tarball on disk (#{actual}) does not match the checksum provided from the mirror (#{desired}). Renaming to #{::File.basename(file_to_check)}.bad")
      ::File.rename(file_to_check, "#{file_to_check}.bad")
      raise
    end
  end
end

action :install do
  # for those odd RHEL systems
  package 'tar'

  group new_resource.splunk_group do
    action :create
    append true
  end

  user new_resource.splunk_user do
    gid new_resource.splunk_group
    shell '/bin/false'
    system true
    action :create
  end

  directory 'splunk install dir' do
    mode '0755'
    path new_resource.install_path
    recursive true
    owner new_resource.splunk_user
    group new_resource.splunk_group
  end

  remote_file "splunk checksum" do
    source checksum_uri
    path "#{Chef::Config['file_cache_path']}/#{new_resource.tarball_name}.md5"
  end

  remote_file "splunk tarball" do
    source tarball_uri
    path "#{Chef::Config['file_cache_path']}/#{new_resource.tarball_name}"
    verify { |file| validate_checksum(file) }
  end

  execute 'extract splunk tarball' do
    command extraction_command
    action :run
    creates ::File.join(new_resource.install_path, 'LICENSE')
  end

  # make sure the instance's user owns the instance install dir
  execute "chown install dir as #{new_resource.splunk_user}" do
    command "chown -R #{new_resource.splunk_user}:#{new_resource.splunk_group} #{new_resource.install_path}"
    action :run
    not_if { Etc.getpwuid(::File.stat("#{new_resource.install_path}/license-eula.txt").uid) == new_resource.splunk_user }
  end

  # enable start a boot
  execute "#{new_resource.install_path}/bin/splunk enable boot-start -user #{new_resource.splunk_user} --accept-license" do
    only_if { ::File.exist? "#{new_resource.install_path}/ftr" }
  end

  # create splunk service
  service 'splunk' do
    supports status: true, restart: true
    action [:enable, :start]
    case node['init_package']
    when 'systemd'
      provider Chef::Provider::Service::Systemd
    else
      provider Chef::Provider::Service::Init
    end
  end
end