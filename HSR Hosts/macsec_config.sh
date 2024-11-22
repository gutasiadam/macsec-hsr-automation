#!/bin/bash
#This script is run locally on the HSR nodes to set up MACsec

# The interface to be used for MACsec
INTERFACE = "hsr0"
MAC_ADDRESS=$(ip link show $INTERFACE | grep link/ether | awk '{print $2}')
KEY_ID="BBBB"
IP_ADDRESS="10.2.0.2/16"

# Create an array of the MAC addresses of the HSR nodes
declare -a OTHER_MAC_ADDRESSES=("00:00:00:00:11:02" "00:00:00:00:33:02")
declare -a OTHER_KEY_IDS=("AAAA" "CCCC")
echo '--------Setting up MACsec----------'
ip link add link $INTERFACE name ms0 type macsec address $MAC_ADDRESS port 1 protect on validate strict encrypt on  
ip macsec add ms0 tx sa 0 pn 1 ssci 1 on key $KEY_ID 0123456789abcdef0123456789abcdef 
ip link set addr $MAC_ADDRESS dev ms0


#For each of the other nodes, add their MAC address and key
for i in "${!OTHER_MAC_ADDRESSES[@]}"; do
    ip macsec add ms0 rx port 1 address ${OTHER_MAC_ADDRESSES[$i]}
    ip macsec add ms0 rx port 1 address ${OTHER_MAC_ADDRESSES[$i]} sa 0 pn 1 ssci 1 on key ${OTHER_KEY_IDS[$i]} 0123456789abcdef0123456789abcdef
done

ip address add $IP_ADDRESS dev ms0 
echo '--------MacSEC setup complete----------' 
ip link set ms0 up
ip route
