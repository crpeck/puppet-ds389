# Class ds389::package
#
# ensure packages are installed
#

class ds389::package {

  package { $ds389::params::package:
    ensure => installed,
  }

}
