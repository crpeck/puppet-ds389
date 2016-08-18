#!/bin/bash
if [ $# -ne 1 ]; then
  echo "usage: $0 file.ldif to load into ldap"
exit 1
if [ -f $1 ]; then
  ldapmodify -v -h localhost -p 389 -D "cn=directory manager" -W -f $1
else
  echo "$0: No such file $1"
  exit 1
end
exit 0
