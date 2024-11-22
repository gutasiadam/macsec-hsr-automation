#!/bin/bash
# This script is used to delete the MACsec on the HSR ring
inventory_file="/home/gutasi/Documents/thesis/Management/ansible/inventory.yaml"
remote_config_script="/home/gutasi/Documents/thesis/"
ansible -i $inventory_file hsr_ring -K -b --become-user=root -m shell -a "$remote_config_script/macsec_delete.sh && ip link del dev hsr0"