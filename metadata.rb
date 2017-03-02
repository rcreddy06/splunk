name 'splunk'
maintainer 'Ryan LeViseur'
maintainer_email 'ryanlev@gmail.com'
license 'Apache 2.0'
description 'Manage Splunk Enterprise or Splunk Universal Forwarder'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
issues_url 'https://github.com/vidkun/splunk/issues' if respond_to?(:issues_url)

# The `source_url` points to the development reposiory for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
source_url 'https://github.com/vidkun/splunk' if respond_to?(:source_url)

chef_version '>= 12.5' if respond_to?(:chef_version)