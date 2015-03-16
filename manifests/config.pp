# Class ds389::config
#
# Creates/Copies these files
# setup.inf - used by setup-ds-admin to install the 389 directory server
#
# $installldiffile = optionally copy over and use a specified ldif file
#   to populate the directory server from
#
# $schemafile = optionally copy over and install a specified schema file
#
# exec the setup-ds-admin script to configure & install the Directory Server
# will NOT run setup-ds-admin if the $serveridentifier instance exists
#
# Note: On Debian systems, I replace
#  /etc/init.d/dirsrv and
#  /etc/init.d/dirsrv-admin
# startup # files, as  a status check didn't exit with a proper return code
# On RedHat systems, /etc/init.d/dirsrv is fine, but dirsrv-admin is not,
# so I replace that one as well.
# Otherwise, these services would either be restarted on every puppet run,
# or never started if they were down.

class ds389::config {

  if ($ds389::params::dirsrv_init != '') {
    file { '/etc/init.d/dirsrv':
      source  => "puppet:///modules/ds389/${ds389::params::dirsrv_init}",
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      require => Package[$ds389::params::package]
    }
  }

  if ($ds389::params::dirsrv_admin_init != '') {
    file { '/etc/init.d/dirsrv-admin':
      source  => "puppet:///modules/ds389/${ds389::params::dirsrv_admin_init}",
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      require => Package[$ds389::params::package]
    }
  }

  if ($ds389::installldiffile != '') and ($ds389::installldiffile != 'suggest') {
    notice ( "Installing LDIF file: ${ds389::installldiffile}" )
    file { "${ds389::dirsrv_dir}/${ds389::installldiffile}":
      source => "puppet:///modules/ds389/${ds389::installldiffile}",
      owner  => 'root',
      group  => 'root',
      mode   => '0664',
      before => Exec['create_dirsrv'],
    }
  }

  if ($ds389::schemafile != '') {
    notice ( "Installing Schema file: ${ds389::schemafile}" )
    file { "${ds389::dirsrv_dir}/${ds389::schemafile}":
      source => "puppet:///modules/ds389/${ds389::schemafile}",
      owner  => 'root',
      group  => 'root',
      mode   => '0664',
      before => Exec['create_dirsrv'],
    }
  }

  file { "${ds389::dirsrv_dir}/setup.inf":
    content => template('ds389/setup.inf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0664',
  }

  exec { 'create_dirsrv':
    command => "${ds389::setup_cmd} -s -f ${ds389::dirsrv_dir}/setup.inf",
    path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    require => File["${ds389::dirsrv_dir}/setup.inf"],
    creates => "${ds389::dirsrv_dir}/slapd-${ds389::serveridentifier}",
  }

}
