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

while getopts ":k:i:u:G:" options; do
    case "${options}" in 
        i)
            username=${OPTARG}
            ;;
        k)
            ssh_key=${OPTARG}
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
SSH_DIR=/home/$username/.ssh

# Making a new ssh directory
mkdir $SSH_DIR
chmod 700 $SSH_DIR

# Generating new keys
ssh-keygen -t ed25519 -f $SSH_DIR/id_ed25519 -q -N ""

# Adding the public key of new keys for inter-node access
cat $SSH_DIR/id_ed25519.pub > $SSH_DIR/authorized_keys

if [ "$ssh_key" = "" ]; then                 # If $NAME is an empty string,
    # Getting SSH keys from user
    echo -n "Enter user's SSH keys: "
    read ssh_key

# Adding user keys to username for easy access
echo $ssh_key >> $SSH_DIR/authorized_keys

echo "Added keys for user $username!"

# Changing file permissions to ensure proper access
chown -R $rUID:$rGID $SSH_DIR