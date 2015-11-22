# Class: mcollective::mqserver
#
# This module manages mcollective server,
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
class mcollective::mqserver (
  $package_ensure = $mcollective::params::package_ensure,
) inherits mcollective::params {
  include ::rabbitmq::server

  rabbitmq_plugin {'rabbitmq_stomp':
    ensure   => present,
    provider => 'rabbitmqplugins',
  }
}
