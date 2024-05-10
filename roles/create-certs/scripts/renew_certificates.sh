#!/bin/bash

# Change directory to Easy-RSA
cd /usr/share/easy-rsa/3

# Initialize the PKI
./easyrsa init-pki

# Build OpenVPN server certificate
./easyrsa build-server-full open_vpn nopass
EASYRSA_BATCH="yes" ./easyrsa build-client-full client_open_vpn nopass

# Generate ta key
cd pki
openvpn --genkey --secret ta.key
