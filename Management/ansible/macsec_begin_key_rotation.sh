#!/bin/bash

inventory_file="/home/gutasi/Documents/thesis/Management/ansible/inventory.yaml"
remote_config_script="/home/gutasi/Documents/thesis"

ansible -i $inventory_file hsr_ring -K -b --become-user=root -m shell -a "$remote_config_script/send_new_keys.sh 2>/dev/null"

