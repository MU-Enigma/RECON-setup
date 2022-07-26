# File to be placed in /usr/local/sbin/deluser_mod/
# Script to remove all LDAP entried of a user
# Author: Srikar (aka epoch101)

# $1 - username
# $2 - UID
# $3 - GID

# Delete the user entry from LDAP
echo "Removing LDAP entry: uid=$1,ou=users,dc=senpai"
ldapdelete -x -D cn=admin,dc=senpai -w $(cat /etc/pam_ldap.conf) uid=$1,ou=users,dc=senpai

# Delete the group entry from LDAP
echo "Removing LDAP entry: cn=$1,ou=groups,dc=senpai"
ldapdelete -x -D cn=admin,dc=senpai -w $(cat /etc/pam_ldap.conf) cn=$1,ou=groups,dc=senpai

# TODO: Delete other group entries as well (check sudo memberID)