#!/bin/bash
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

# Delete other group entries as well 
# Getting all the groups the user is a part of in LDAP
LDAP_GRPS_LIST=$(ldapsearch -x -D cn=admin,dc=senpai -b ou=groups,dc=senpai -w $(cat /etc/pam_ldap.conf) memberUid=$1 cn | grep cn:)
LDAP_GRPS_LIST=$(echo $LDAP_GRPS_LIST | sed -e "s/cn://g")

# Get all groups
# Iterate through all the results
if [ -n "$LDAP_GRPS_LIST" ];then
	for gName in $LDAP_GRPS_LIST
	do
		# Removing user entry from a specific group
		echo "dn: cn=$gName,ou=groups,dc=senpai
		changetype: modify
		delete: memberUid
		memberUid: $1" | ldapmodify -x -D cn=admin,dc=senpai -w $(cat /etc/pam_ldap.conf)
	done
fi