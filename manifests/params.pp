# Class ds389::params
#
# Defines all the variables used in the module
#
class ds389::params {

  $dirsrv_dir              = '/etc/dirsrv'

  $fullmachinename         = $::fqdn
  $suite_spot_userid         = 'dirsrv'
  $suite_spot_group          = 'dirsrv'
  $configdirectoryldapurl  = "ldap://${::fqdn}:389/o=netscaperoot"
  $admindomain             = 'example.com'
  $configdirectoryadminid  = 'admin'
  $configdirectoryadminpwd = 'changeit'
  $cacertificate           = ''
  $serverport              = '389'
  $serveridentifier        = 'ldap'
  $suffix                  = 'dc=example,dc=com'
  $rootdn                  = 'cn=Directory Manager'
  $rootdnpwd               = 'changeit'
  $addorgentries           = 'yes'
  $installldiffile         = 'suggest'
  $schemafile              = ''
  $configfile              = ''
  $slapdconfigformc        = 'yes'
  $useexistingmc           = 'no'
  $sysuser                 = 'dirsrv'
  $port                    = '9830'
  $serveradminid           = 'admin'
  $serveradminpwd          = 'changeit'
  $serveripaddress         = $::ipaddress
  $service_name            = 'dirsrv'
  $admin_service_name      = 'dirsrv-admin'

  case $::osfamily {
    'Debian': {
      $package            = [ '389-ds',
                              'ldap-utils',
                              'xauth',
                            ]
      $setup_cmd          = '/usr/sbin/setup-ds-admin'
      $dirsrv_init        = "dirsrv_init.${::osfamily}"
      $dirsrv_admin_init  = "dirsrv_admin_init.${::osfamily}"
    }
    'RedHat': {
      $package            = [ '389-ds',
                              'openldap-client',
                              'liberation-sans-fonts',
                              'xorg-x11-xauth',
                            ]
      $setup_cmd          = '/usr/sbin/setup-ds-admin.pl'
      $dirsrv_init        = ''
      $dirsrv_admin_init  = "dirsrv_admin_init.${::osfamily}"
    }
    default: {
      fail("${::operatingsystem} not supported for 389ds. Modify params.pp.")
    }
  }
}

