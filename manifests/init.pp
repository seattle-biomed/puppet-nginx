# Class: nginx
#
# This module manages NGINX.
#
# Parameters:
#
# There are no default parameters for this class. All module parameters are managed
# via the nginx::params class
#
# Actions:
#
# Requires:
#  puppetlabs-stdlib - https://github.com/puppetlabs/puppetlabs-stdlib
#
#  Packaged NGINX
#    - RHEL: EPEL or custom package
#    - Debian/Ubuntu: Default Install or custom package
#    - SuSE: Default Install or custom package
#
#  stdlib
#    - puppetlabs-stdlib module >= 0.1.6
#    - plugin sync enabled to obtain the anchor type
#
# Sample Usage:
#
# The module works with sensible defaults:
#
# node default {
#   include nginx
# }
class nginx (
  $worker_processes   = $nginx::params::nx_worker_processes,
  $worker_connections = $nginx::params::nx_worker_connections,
  $proxy_set_header   = $nginx::params::nx_proxy_set_header,
  $confd_purge        = $nginx::params::nx_confd_purge,
  $configtest_enable  = $nginx::params::nx_configtest_enable,
  $service_restart    = $nginx::params::nx_service_restrart,
  $resource_locations = hash([]),
  $resource_upstreams = hash([]),
  $resource_vhosts    = hash([]),
) inherits nginx::params {

  warning('This module, puppet-nginx, is no longer supported and we direct you to our upstream source, http://forge.puppetlabs.com/jfryman/nginx')

  validate_hash($resource_locations)
  validate_hash($resource_upstreams)
  validate_hash($resource_vhosts)

  class { '::nginx::package':
    notify => Class['::nginx::service'],
  }

  class { '::nginx::config':
    worker_processes    => $worker_processes,
    worker_connections  => $worker_connections,
    proxy_set_header    => $proxy_set_header,
    confd_purge         => $confd_purge,
    require             => Class['::nginx::package'],
    notify              => Class['::nginx::service'],
  }

  class { '::nginx::service':
    configtest_enable => $configtest_enable,
    service_restart   => $service_restart,
  }

  # Allow the end user to establish relationships to the "main" class
  # and preserve the relationship to the implementation classes through
  # a transitive relationship to the composite class.
  anchor{ 'nginx::begin':
    before => Class['nginx::package'],
    notify => Class['nginx::service'],
  }
  anchor { 'nginx::end':
    require => Class['nginx::service'],
  }

  # Create resources from Hiera data.
  create_resources(nginx::resource::location,$resource_locations)
  create_resources(nginx::resource::upstream,$resource_upstreams)
  create_resources(nginx::resource::vhost,$resource_vhosts)
}
