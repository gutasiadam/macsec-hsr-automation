#!/bin/bash
# This script is used to generate a random key for MACsec, using the urandom device
# The key is then printed in hex format
# Note that /dev/urandom keys are not secure, and should be replaced with a secure key generation method in a real deployment

cat /dev/urandom | xxd -p | head -c 32
