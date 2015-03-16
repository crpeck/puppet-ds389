# Class ds389::service
#
# ensure service is running
#
class ds389::service {

  service { $ds389::params::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

  service { $ds389::params::admin_service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}

