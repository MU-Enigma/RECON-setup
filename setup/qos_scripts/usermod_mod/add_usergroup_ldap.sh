# File to be placed in /usr/local/sbin/usermod_mod
# Script to :
# 	1. Check if a group exists in the LDAP database and create if not
# 	2. Add the user if not in the specified group
# Author: Srikar (aka epoch101)

# $1 - username
# $2 - GID

# Getting the group name
gName=$(getent group $2 | sed 's/:.*//')

# Checking if group exists in LDAP
isExist=$(ldapsearch -x -D cn=admin,dc=senpai -b ou=groups,dc=senpai -w $(cat /etc/pam_ldap.conf) gidNumber=$2 | grep cn)

# If LDAP group doesn't exist, make one
if ! [ -n "$isExist" ];then

	cd /usr/local/sbin/useradd_mod/ldif_editors
	
	# Make a temporary ldapgroups.ldif
	cp ldapgroups.ldif temp-ldapgroups.ldif

	# Add user group details in temp user group ldif
	sed -i "s/theGroupName/$gName/g" temp-ldapgroups.ldif
	sed -i "s/theMemberUid/$1/g" temp-ldapgroups.ldif
	sed -i "s/theGID/$2/g" temp-ldapgroups.ldif

	# Add the updated usergroup file to LDAP database
	ldapadd -x -D cn=admin,dc=senpai -w $(cat /etc/pam_ldap.conf) -f temp-ldapgroups.ldif

	rm -fr temp-ldapgroups.ldif

else
	# Add the user to the LDAP group
	echo "dn: cn=$gName,ou=groups,dc=senpai
	changetype: modify
	add: memberUid
	memberUid: $1" | ldapmodify -x -D cn=admin,dc=senpai -w $(cat /etc/pam_ldap.conf)
fi