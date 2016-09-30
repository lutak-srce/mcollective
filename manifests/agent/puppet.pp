#
# = Class: mcollective::agent::puppet
#
# This module installs mcollective agent 'puppet'
#
class mcollective::agent::puppet {

  package { 'mcollective-puppet-agent': }

}
