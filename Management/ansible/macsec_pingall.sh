#!/bin/bash
# This script is used to test the connectivity between the nodes on the HSR ring.
remote_config_script="/home/gutasi/Documents/thesis"

ansible -i $inventory_file hsr_ring -K -b --become-user=root -m shell -a "$remote_config_script/debug/pingall.sh | grep %"
