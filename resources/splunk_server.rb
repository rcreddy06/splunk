resource_name :splunk_server

property :install_path, String, default: "/opt/splunk"
# tarball name and uri will need to be updated for every new release since Splunk can't 
# seem to just provide a standard uri scheme for pulling these.
property :tarball_name, String, default: 'splunk-6.5.2-67571ef4b87d-Linux-x86_64.tgz'
property :tarball_uri, String, default: lazy { |r| "https://download.splunk.com/products/splunk/releases/6.5.2/linux/#{r.tarball_name}" }
property :checksum_uri, String, default: lazy { |r| "#{r.tarball_uri}.md5" }
property :splunk_user, String, default: 'splunk'
property :splunk_group, String, default: 'splunk'

default_action :install

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