#
# = Class: mcollective::client
#
# This module manages mcollective client, which will send commands
# to mcollective.
#
class mcollective::client (
  $ensure      = 'present',
  $package     = $::mcollective::params::package_client,
  $version     = 'present',
  $mq_master   = 'localhost',
  $mq_user     = 'guest',
  $mq_password = 'guest',
  $mq_port     = '61613',
  $noops       = undef,
) inherits mcollective::params {

  ### Input parameters validation
  validate_re($ensure, ['present','absent'], 'Valid values are: present, absent')
  validate_string($package)
  validate_string($version)

  ### Internal variables (that map class parameters)
  if $ensure == 'present' {
    $package_ensure = $version ? {
      ''      => 'present',
      default => $version,
    }
    $file_ensure = present
  } else {
    $package_ensure = 'absent'
    $file_ensure    = absent
  }

  package { 'mcollective-client':
    ensure => $package_ensure,
    name   => $package,
    noop   => $noops,
  }

  file { '/etc/mcollective/client.cfg':
    ensure  => $file_ensure,
    content => template('mcollective/client.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    require => Package['mcollective-client'],
  }

}
