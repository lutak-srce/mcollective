# Class: mcollective::params
#
#   The mcollective configuration settings.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class mcollective::params {
  $mqmaster       = 'localhost'
  $mquser         = 'guest'
  $mqpassword     = 'guest'
  $mqport         = '61613'
  $rebuild_facts  = false
  $package_ensure = 'present'
}
