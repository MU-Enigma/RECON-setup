# File to be placed in /usr/local/sbin/adduser_mod/ssh-keymgmt
# Script to :
#	1. Get user input for custom keys and add them to authorized_keys
#	2. Generate new set of keys for inter-node access in the cluster
# Author: Srikar (aka epoch101)

# $1 - username
# $2 - UID
# $3 - GI
# SSH_DIR - /home/$1/.ssh

SSH_DIR=/home/$1/.ssh

# Making a new ssh directory
mkdir $SSH_DIR
chmod 700 $SSH_DIR

# Generating new keys
ssh-keygen -t ed25519 -f $SSH_DIR/id_ed25519 -q -N ""

# Adding the public key of new keys for inter-node access
cat $SSH_DIR/id_ed25519.pub > $SSH_DIR/authorized_keys

# Getting SSH keys from user
echo -n "Enter user's SSH keys: "
read user_sshkeys

# Adding user keys to username for easy access
echo $user_sshkeys >> $SSH_DIR/authorized_keys

echo "Added keys for user $1!"

# Changing file permissions to ensure proper access
chown -R $2:$3 $SSH_DIR