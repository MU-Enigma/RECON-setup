#!/bin/bash
# File to be placed in /usr/local/sbin/useradd_mod/ldif_editors
# Script to generate valid ldif for a new user
# Author: Srikar (aka epoch101)

# $1 - username
# $2 - UID
# $3 - GID

# Change directory for easy access
cd /usr/local/sbin/useradd_mod/ldif_editors

# Make a temporary ldapusers.ldif
cp ldapusers.ldif temp-ldapusers.ldif

# Adding user details in temp user ldif
sed -i "s/theUsername/$1/g" temp-ldapusers.ldif
sed -i "s/theUID/$2/g" temp-ldapusers.ldif
sed -i "s/theGID/$3/g" temp-ldapusers.ldif

# Make a temporary ldapgroups.ldif
cp ldapgroups.ldif temp-ldapgroups.ldif

# Add user group details in temp user group ldif
sed -i "s/theGroupName/$1/g" temp-ldapgroups.ldif
sed -i "s/theMemberUid/$1/g" temp-ldapgroups.ldif
sed -i "s/theGID/$3/g" temp-ldapgroups.ldif

# Add the updated user file to LDAP database
ldapadd -x -D cn=admin,dc=senpai -w $(cat /etc/pam_ldap.conf) -f temp-ldapusers.ldif

# Add the updated usergroup file to LDAP database
ldapadd -x -D cn=admin,dc=senpai -w $(cat /etc/pam_ldap.conf) -f temp-ldapgroups.ldif

# Remove all the modified files, ready the dir for next useradd :)
rm -fr temp-*

# NOTE: Bash scripting is fun. You should embrace it and enjoy automation