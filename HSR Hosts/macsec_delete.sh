#!/bin/bash
#This script is used to delete the MACsec configuration on the HSR ring hosts.
ip link set ms0 down
ip link del dev ms0
