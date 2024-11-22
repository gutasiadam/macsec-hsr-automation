#!/bin/bash
# Pings all the IP addresses in the array IP_ADDRESSES
declare -a IP_ADDRESSES=("10.2.0.1" "10.2.0.2" "10.2.0.3")

for i in "${!IP_ADDRESSES[@]}"; do
    ping ${IP_ADDRESSES[$i]} -c 1
done
