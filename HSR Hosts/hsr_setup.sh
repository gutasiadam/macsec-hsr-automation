#!/bin/bash
# This scripts sets up HSR interface on the ring nodes

Slave_1="ens37"
Slave_2="ens38"
echo '-------Setting up HSR -------'
ip link add name hsr0 type hsr slave1 $Slave_1 slave2 $Slave_2 version 1 proto 0
ip link set hsr0 up
echo '-------HSR setup complete-------'
sleep 5
cat /sys/kernel/debug/hsr/hsr0/node_table
