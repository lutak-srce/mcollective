# Class: mcollective
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
  $mqmaster       = $mcollective::params::mqmaster,
  $mquser         = $mcollective::params::mquser,
  $mqpassword     = $mcollective::params::mqpassword,
  $mqport         = $mcollective::params::mqport,
  $rebuild_facts  = $mcollective::params::rebuild_facts,
  $package_ensure = $mcollective::params::package_ensure,
) inherits mcollective::params {
  package { 'mcollective':
    ensure  => $package_ensure,
  }
  package { 'mcollective-puppet-agent':
    ensure => present,
  }
  case $::operatingsystem {
    default: {
    }
    'CentOS' : {
      package { 'mcollective-service-agent':
        ensure => present,
      }
    }
    'Fedora' : {
    }
  }
  package { 'rubygem-stomp':
    ensure  => $package_ensure,
  }
  service { 'mcollective':
    ensure   => 'running',
    enable   => true,
    provider => 'redhat',
    require  => Package['mcollective'],
  }
  # set up server config file
  file { '/etc/mcollective/server.cfg':
    ensure  => present,
    content => template('mcollective/server.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    require => Package['mcollective'],
    notify  => Service['mcollective'],
  }
  # build facts.yaml from facter
  if $rebuild_facts == true {
    file { '/etc/mcollective/facts.yaml':
      ensure   => present,
      # avoid including highly-dynamic facts as they will cause unnecessary template writes
      content  => inline_template('<%= Hash[scope.to_hash.reject { |k,v| k.to_s =~ /(uptime|timestamp|memory|free|swap|path)/ }.sort].to_yaml %>'),
      owner    => root,
      group    => root,
      mode     => '0400',
      require  => Package['mcollective'],
      notify   => Service['mcollective'],
      loglevel => 'debug',  # this is needed to avoid it being logged and reported on every run
    }
  }
}
