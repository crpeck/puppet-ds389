# == Class: ds389
#
# Installation and configuration of the Fedora 389 Directory Server
#
# === parameters
#
# dirsrv_dir
#   Directory where it lives, almost always /etc/dirsrv
#
# The following are used by the setup.inf file that controls
# the behavior of setup-ds-admin, the installation script.
# These variable names are the same (except for being lower-case)
# as used in that file, as defined at
# http://directory.fedoraproject.org/wiki/FDS_Setup
#
# --- General Section
#
# fullmachinename
# Default: $fqdn as returned by facter
#   the FQDN that you want the server to listen to.
#   This value has significance for a number of reasons:
#   The default server identifier will be derived from this (e.g. slapd-foo)
#   The default suffix will be derived from the domain part
#   (e.g. dc=example,dc=com)
#   If you use SSL, this must match exactly the leftmost CN value in the server
#   certificate's subjectDN field e.g.
#   cn=foo.example,com,ou=Fedora Directory Server
#   If you use Kerberos, this must be the value used in the server principal
#   e.g. ldap/foo.example.com@EXAMPLE.COM
#
# suite_spot_userid
# Default: dirsrv
#   the user id you want the server to run as. Note that you do not have
#   to use root in order for the server to listen to the default port
#   389. As long as the server is started as root, it will drop
#   privileges (seteuid()) after binding to the low ports. In fact, you
#   are strongly encouraged to use a non-privileged user instead of root.
#   If you run setup as a non-root user, you must choose your userid.
#
# suite_spot_group
# Default: dirsrv
#   the group id that you want the server specific files and directories
#   to be owned by. You would use this primarily if you already had some
#   sort of local machine administrative group, or if you want to run the
#   admin server as a different user id but allow it to manage directory
#   server files and directories. The SuiteSpotUserID must already be a
#   member of this group.
#
# configdirectoryldapurl
# Default: ldap://FullMachineName:398/o=NetscapeRoot
#   The LDAP URL of the configuration directory server, the one holding
#   the master copy of the o=NetscapeRoot data used to store admin server
#   and console configuration.
#
# admindomain
# Default: domain part of FullMachineName
#   This should generally just be the same as your domain name.
#
# configdirectoryadminid
# Default: admin
#   The console/admin server administrator user ID.
#
# configdirectoryadminpwd
# Default: changeit
#   The console/admin server administrator password.
#
# cacertificate
# Default: None
#   If the ConfigDirectoryLdapURL uses LDAPS, you can specify the CA
#   certificate to use. You can specify either the full path and filename
#   of the ASCII/PEM encoded CA certificate (e.g. /path/to/cacert.asc),
#   or you can specify the actual CA certificate ASCII/PEM value
#   (e.g. -----BEGIN CERTIFICATE-----\n.......)
#
#
# --- slapd Section
# serverport
# Default: 389
#   the network port number the server will listen to. If using ldapi,
#   you can specify a value of "0" here to tell the server not to listen
#   to a network port. You must run setup as root in order to use the
#   default port 389.
#
# serveridentifier
# Default: hostname part of FullMachineName
#   This is the server instance identifier used to name filesystem paths
#   associated with this instance of directory server. By default, it is
#   the leftmost component of the FullMachineName. For example, if the
#   value is 'foo', this will be used in /etc/dirsrv/slapd-foo,
#   /var/log/dirsrv/slapd-foo, /var/lib/dirsrv/slapd-foo, etc. This will
#   also be used as the name of this server in the console and admin
#   server.
#
# suffix
# Default: domain part of FullMachineName in dc= style
#   the default suffix used to store your data. The default is the domain
#   part of FullMachineName converted to dc= style - foo.example,com ->
#   dc=example,dc=com. The server will create this suffix, the associated
#   database (userRoot), and a simple DIT to use.
#
# rootdn
# Default: cn=Directory Manager
#  the directory manager DN. This is the 'superuser' for your directory
#  server.
#
# rootdnpwd
# Default: changeit
#   the password for the directory manager. This value can be passed in
#   clear text or pre-hashed using the pwdhash command.
#
# installldiffile
# Default: suggest
#   You can have setup populate your new directory server with an LDIF
#   file. The default value is "suggest" which means setup will create a
#   simple DIT. Use a value of "none" to create an empty DIT. If you want
#   to use your own LDIF file, you must specify the full path and
#   filename. If the data uses custom schema, see SchemaFile below for
#   how to add your custom schema.
#
# schemafile
# Default: none
#   This is a multi-valued parameter, and can be specified more than
#   once. This is the full path and filename of a Fedora DS schema file
#   with the appropriate name that begins with two digits and is in LDIF
#   format (e.g. /path/to/60myschema.ldif). This file will be copied into
#   the schema directory of the new instance.
#
# configfile
# Default: none
#   This is a multi-valued parameter, and can be specified more than once.
#   This is the full path and filename of an LDIF file containing one or
#   more entries to be placed into the new dse.ldif configuration file.
#   This could contain additional suffix/database definitions,
#   replication configuration, etc.
#
# slapdconfigformc
# Default: false
#   if true (1), configure this new DS instance as a
#   Configuration Directory Server
#
# useexistingmc
# Default: false
#   if true (1), register this DS with the Configuration DS
#
# --- admin Section
#
# sysuser
# Default: SuiteSpotUserID
#   the admin server user id - the default is the value of
#   SuiteSpotUserID, which means by default the directory server and
#   admin server will run as the same user id
#
# port
# Default: 9830
#   the network port admin server will listen to
#
# serveradminid
# Default: ConfigDirectoryAdminID
#   This is used for fallback http auth in case LDAP is down
#
# serveradminpwd
# Default: gets set to the same as ConfigDirectoryAdminPwd
#   the password for ServerAdminID
#
# serveripaddress
# Default: $ipaddress from facter
#   by default the admin server will listen to all interfaces
#   - you can specify a single IP address to listen to
#
#
# === variables
#
# All required variables have a default defined in params.pp
#
# === examples
#
#  Class { ds389:
#    rootdnpwd        => 'rootdn-password',
#    serveridentifier => 'prod',
#    schemafile       => '99user.ldif',
#  }
#
# === authors
#
# Chris Peck <crpeck@wm.edu>
#
# === copyright
#
#
class ds389 (
  $dirsrv_dir              = $ds389::params::dirsrv_dir,
  $fullmachinename         = $ds389::params::fullmachinename,
  $suite_spot_userid         = $ds389::params::suite_spot_userid,
  $suite_spot_group          = $ds389::params::suite_spot_group,
  $configdirectoryldapurl  = $ds389::params::configdirectoryldapurl,
  $admindomain             = $ds389::params::admindomain,
  $configdirectoryadminid  = $ds389::params::configdirectoryadminid,
  $configdirectoryadminpwd = $ds389::params::configdirectoryadminpwd,
  $cacertificate           = $ds389::params::cacertificate,
  $serverport              = $ds389::params::serverport,
  $serveridentifier        = $ds389::params::serveridentifier,
  $suffix                  = $ds389::params::suffix,
  $rootdn                  = $ds389::params::rootdn,
  $rootdnpwd               = $ds389::params::rootdnpwd,
  $installldiffile         = $ds389::params::installldiffile,
  $schemafile              = $ds389::params::schemafile,
  $configfile              = $ds389::params::configfile,
  $slapdconfigformc        = $ds389::params::slapdconfigformc,
  $useexistingmc           = $ds389::params::useexistingmc,
  $sysuser                 = $ds389::params::sysuser,
  $port                    = $ds389::params::port,
  $serveradminid           = $ds389::params::serveradminid,
  $serveradminpwd          = $ds389::params::serveradminpwd,
  $serveripaddress         = $ds389::params::serveripaddress,
  ) inherits ds389::params {

  validate_string(fullmachinename,
    suite_spot_userid,
    suite_spot_group,
    suite_spot_group,
    configdirectoryldapurl,
    admindomain,
    configdirectoryadminid,
    cacertificate,
    serverport,
    serveridentifier,
    suffix,
    rootdn,
    rootdnpwd,
    installldiffile,
    schemafile,
    configfile,
    slapdconfigformc,
    useexistingmc,
    sysuser,
    port,
    serveradminid,
    serveradminpwd,
    serveripaddress
  )

  include ds389::package
  include ds389::config
  include ds389::service

  anchor { 'ds389_start': } ->
  Class [ 'ds389::package' ] ->
  Class [ 'ds389::config' ] ->
  Class [ 'ds389::service' ] ->
  anchor { 'ds389_end': }

}
