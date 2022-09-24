#!/bin/bash
# File to be placed in /usr/local/sbin/useradd_mod/ssh-keymgmt
# Script to :
#	1. Get user input for custom keys and add them to authorized_keys
#	2. Generate new set of keys for inter-node access in the cluster
# Author: Srikar (aka epoch101)

# $1 - username
# $2 - UID
# $3 - GID
# SSH_DIR - /home/$1/.ssh
echo "$1 $2 $3 $4 $5 $6 $7 $8"
while getopts ":i:k:u:G:" options; do
    echo "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    echo $OPTARG
    case "${options}" in 
        i)
            username=${OPTARG}
            ;;
        k)
            SSH_KEY=${OPTARG}
	    echo "gen_new $SSH_KEY"
            ;;
        u)
            rUID=${OPTARG}
            ;;
        G)
            rGID=${OPTARG}
            ;;
        :)
            echo "unknown FLAG error"
            ;;
    esac
done
echo "hi"
SSH_DIR=/home/$username/.ssh

# Making a new ssh directory
mkdir $SSH_DIR
chmod 700 $SSH_DIR

# Generating new keys
ssh-keygen -t ed25519 -f $SSH_DIR/id_ed25519 -q -N ""

# Adding the public key of new keys for inter-node access
cat $SSH_DIR/id_ed25519.pub > $SSH_DIR/authorized_keys

echo "Hi send help: $SSH_KEY"
echo "Am I used?"
if ! [ -n "$SSH_KEY" ]; then                 # If ssh key is an empty string,
    # Getting SSH keys from user
    echo -n "Enter user's SSH keys please: "
    read SSH_KEY
fi

# Adding user keys to username for easy access
echo $SSH_KEY >> $SSH_DIR/authorized_keys

echo "Added keys for user $username!"

# Changing file permissions to ensure proper access
chown -R $rUID:$rGID $SSH_DIR
