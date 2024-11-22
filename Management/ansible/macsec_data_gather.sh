#!/bin/bash
# This script is used to gather the MACsec data from the HSR ring in JSON format.

inventory_file="/home/gutasi/Documents/thesis/Management/ansible/inventory.yaml"
remote_config_script="/home/gutasi/Documents/thesis"

ansible -i $inventory_file hsr_ring -a "python3 $remote_config_script/collect_macsec_data.py"
