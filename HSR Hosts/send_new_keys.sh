#!/bin/bash

# This script is used to generate a new key for MACsec, and distribute it to the ring devices

# Load the current SA
source SA.sh
KEYFILE="/var/tmp/new-key.txt"
MAC_ADDR=00:00:00:00:22:02
scripts_folder="/home/gutasi/Documents/thesis"

# Remote HSR ip addresses
declare -a HOST_ADDRESSES=("10.2.0.1" "10.2.0.3")

# Set verbosity to 1 to enable debug output
VERBOSE=0

if [ $VERBOSE -eq 1 ]; then
	echo 'Removing old key...'
fi

sed -i '$ d' $KEYFILE

if [ $VERBOSE -eq 1 ]; then
	echo 'Generating new secret'
fi

#Use gen_key.sh to generate a new key. Store the key in KEY and the key ID in KEYID
KEYID=$(sh $scripts_folder/gen_key.sh)
KEY=$(sh $scripts_folder/gen_key.sh)

# Set env variables
export MAC_ADDR
export KEYID

if [ $VERBOSE -eq 1 ]; then
	echo 'Setting up new association number... Current SA is $SA'
fi
if [ "$SA" -eq 0 ]; then
	SA=1
elif [ "$SA" -eq 1 ]; then
	SA=0
else
	#"SA is neither 0 nor 1. Defaulting to 1, as the primary setup uses SA 0."
	SA=1
fi
export SA

if [ $VERBOSE -eq 1 ]; then
	echo "export SA=$SA" > SA.sh
	echo -e "New SA: $SA"
	echo "Saving to temp file"
	echo -e "$MAC_ADDR\t$SA\t$KEYID\t$KEY" >> /var/tmp/mykey.txt
	echo 'Distributing new key to the ring devices'
fi

for i in "${!HOST_ADDRESSES[@]}"; do
	scp -o ConnectTimeout=3 -q /var/tmp/mykey.txt gutasi@${HOST_ADDRESSES[$i]}:/var/tmp/new-key.txt
done

if [ $VERBOSE -eq 1 ]; then
	echo -e 'Adding new TX SA to macsec interface'
fi
ip macsec add ms0 tx sa $SA pn 1 ssci 1 off key $KEYID $KEY
ip macsec show


if [ $VERBOSE -eq 1 ]; then
	echo -e 'Cleaning up...'
fi
unset KEY
cd $scripts_folder

#Invoke the python script to send the key metadata to the controller

python3 send_key_metadata.py
if [ $VERBOSE -eq 1 ]; then
	echo 'Py process complete'
fi
