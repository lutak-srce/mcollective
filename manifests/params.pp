#
# = Class: mcollective::params
#
#   The mcollective configuration settings.
#
class mcollective::params {

  # install package depending on major version
  case $::osfamily {
    default: {}
    /(RedHat|redhat|amazon|Debian|debian|Ubuntu|ubuntu)/: {
      $package        = 'mcollective'
      $service        = 'mcollective'
      $package_client = 'mcollective-client'
    }
  }

}
