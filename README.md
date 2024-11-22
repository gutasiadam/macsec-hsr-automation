# MACSec Key Distribution and Automation using Ansible

## Introduction

This project is to automate the MACSec key distribution and configuration on switches in the HSR ring using Ansible. It is part of a thesis, aiming to provide enhanced security on premises of smartgrid power stations.

## Pre-requisites
This PoC is designed to be run on a Linux machine. Because of interface configurations, root access is required.
Files in foldes 'HSR Hosts' should be copied to each switch in the HSR ring.
Files in folder 'Management' should be copied to the supervising machine.

## Setup
Each script file contains some variables that need to be adjusted to the specific environment, for example, the IP addresses of the switches, the interface names, and the MACSec key ID's

### Inventory

The inventory file should be updated with the IP addresses of the switches. The switches should be grouped as 'hsr_ring' in the inventory file.

## Usage
First, macsec_prepare.sh should be run on the Management host. This will configure the interfaces and MACSec keys on the switches. Optionally, connectivity can be verified using the macsec_pingall.sh script.

After that, once the key is getting expired, gen_key.sh should be run on the host that's SA is getting expired. 'send_new_keys.sh' distributes it to the other participants, and returns key metadata to the Ansible host.

