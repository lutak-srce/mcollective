#
# = Class: mcollective
#
# This module manages mcollective and is standard for all hosts
#
# Requires:
#   $mcollective_master   must be set in hiera
#   $mcollective_user     must be set in hiera
#   $mcollective_password must be set in hiera
#
# Sample Usage:
#   include mcollective
#
class mcollective (
  $ensure           = 'present',
  $package          = $::mcollective::params::package,
  $version          = undef,
  $service          = $::mcollective::params::service,
  $status           = 'enabled',
  $mq_master        = 'localhost',
  $mq_user          = 'guest',
  $mq_password      = 'guest',
  $mq_port          = '61613',
  $rebuild_facts    = false,
  $dependency_class = undef,
  $my_class         = undef,
  $noops            = undef,
) inherits mcollective::params {

  ### Input parameters validation
  validate_re($ensure, ['present','absent'], 'Valid values are: present, absent')
  validate_string($package)
  validate_string($version)
  validate_string($service)
  validate_re($status, ['enabled','disabled','running','stopped','activated','deactivated','unmanaged'], 'Valid values are: enabled, disabled, running, stopped, activated, deactivated and unmanaged')

  ### Internal variables (that map class parameters)
  if $ensure == 'present' {
    $package_ensure = $version ? {
      ''      => 'present',
      default => $version,
    }
    $service_enable = $status ? {
      'enabled'     => true,
      'disabled'    => false,
      'running'     => undef,
      'stopped'     => undef,
      'activated'   => true,
      'deactivated' => false,
      'unmanaged'   => undef,
    }
    $service_ensure = $status ? {
      'enabled'     => 'running',
      'disabled'    => 'stopped',
      'running'     => 'running',
      'stopped'     => 'stopped',
      'activated'   => undef,
      'deactivated' => undef,
      'unmanaged'   => undef,
    }

    $file_ensure = present
  } else {
    $package_ensure = 'absent'
    $service_enable = undef
    $service_ensure = stopped
    $file_ensure    = absent
  }

  ### Extra classes
  if $dependency_class { include $dependency_class }
  if $my_class         { include $my_class         }

  package { 'mcollective':
    ensure => $package_ensure,
    name   => $package,
    noop   => $noops,
  }

  service { 'mcollective':
    ensure  => $service_ensure,
    name    => $service,
    enable  => $service_enable,
    require => Package['mcollective'],
    noop    => $noops,
  }

  # set up server config file
  file { '/etc/mcollective/server.cfg':
    ensure  => $file_ensure,
    content => template('mcollective/server.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    require => Package['mcollective'],
    notify  => Service['mcollective'],
    noop    => $noops,
  }

  # build facts.yaml from facter
  if $rebuild_facts == true {
    file { '/etc/mcollective/facts.yaml':
      ensure   => $file_ensure,
      # avoid including highly-dynamic facts as they will cause unnecessary template writes
      content  => inline_template('<%= Hash[scope.to_hash.reject { |k,v| k.to_s =~ /(uptime|timestamp|memory|free|swap|path)/ }.sort].to_yaml %>'),
      owner    => root,
      group    => root,
      mode     => '0400',
      require  => Package['mcollective'],
      notify   => Service['mcollective'],
      loglevel => 'debug',  # this is needed to avoid it being logged and reported on every run
      noop     => $noops,
    }
  }

}
