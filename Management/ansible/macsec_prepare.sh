#!/bin/bash
# This script is used to configure the MACsec on the HSR ring
# It then tests the connectivity between the nodes.

inventory_file="/home/gutasi/Documents/thesis/Management/ansible/inventory.yaml"
remote_config_script="/home/gutasi/Documents/thesis"


ansible -i $inventory_file hsr_ring -K -b --become-user=root -m shell -a "$remote_config_script/hsr_setup.sh && $remote_config_script/macsec_config.sh && ip -s macsec show"
ansible -i $inventory_file hsr_ring -K -b --become-user=root -m shell -a "$remote_config_script/debug/pingall.sh | grep %"

