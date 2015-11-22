# Class: mcollective::plugins
#
# This module manages mcollective plugins
#
# Requires:
#
# Sample Usage:
#   include mcollective::plugins
#
class mcollective::plugins {
  # custom addons
  # shellcmd.rb, executes any shell command
  file { '/usr/libexec/mcollective/mcollective/agent/shellcmd.rb':
    ensure  => present,
    source  => 'puppet:///modules/mcollective/agent/shellcmd.rb',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['mcollective'],
    notify  => Service['mcollective'],
  }
  # puppetd, runs puppet client on nodes
  file { '/usr/libexec/mcollective/mcollective/agent/puppetd.rb':
    ensure  => present,
    source  => 'puppet:///modules/mcollective/agent/puppetd.rb',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['mcollective'],
    notify  => Service['mcollective'],
  }
  file { '/usr/libexec/mcollective/mcollective/agent/puppetd.ddl':
    ensure  => present,
    source  => 'puppet:///modules/mcollective/agent/puppetd.ddl',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['mcollective'],
    notify  => Service['mcollective'],
  }
}
