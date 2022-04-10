# NOTE: DO NOT use this. Made for temporary testing. Make sure to configure interfaces to persist across reboots but using the config file
sudo modprobe 8021q
sudo ip link add link eth0 name eth0.10 type vlan id 10
sudo ip addr add 192.168.1.1/24 dev eth0.10
