# Class: mcollective::mqclient
#
# This module manages mcollective client,
# and installs only on master
#
# Requires:
#   $mcollective_master   must be set in hiera
#   $mcollective_user     must be set in hiera
#   $mcollective_password must be set in hiera
#
# Sample Usage:
#   include mcollective
#
class mcollective::mqclient (
  $package_ensure = $mcollective::params::package_ensure,
) inherits mcollective::params {
  # set up client
  package { 'mcollective-client': ensure => $package_ensure, }

  file { '/etc/mcollective/client.cfg':
    ensure  => present,
    content => template('mcollective/client.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    require => Package['mcollective-client'],
  }
}
