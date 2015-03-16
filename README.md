What is it?
===========

Puppet module to install and configure [389-ds](http://directory.fedoraproject.org/) - a full featured LDAP server.

Usage:
======

Include the ds389 module and it will install and configure an LDAP server.

<pre>
  class { '::ds389':
    rootdnpwd        => 'testing1',
    serveradminid    => 'admin',
    serveridentifier => 'prod',
    schemafile       => '99user.ldif',
  }
</pre>

License:
--------
Released under the Apache 2.0 licence

Contribute:
-----------
* Fork it
* Create a topic branch
* Improve/fix (with spec tests)
* Push new topic branch
* Submit a PR


