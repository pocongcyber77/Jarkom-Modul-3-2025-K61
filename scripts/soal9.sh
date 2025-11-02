#!/bin/bash

ip addr flush dev eth0
ip addr add 10.94.4.10/24 dev eth0
ip route add default via 10.94.4.1
echo "Testing Palantir API:"; curl -s http://10.94.3.11:8000/api/airing
echo "Testing Elros reverse proxy:"; curl -s http://10.94.1.33/
echo "Testing Pharazon reverse proxy:"; curl -u noldor:silvan -H 'X-Real-IP:10.94.4.10' http://10.94.1.13/
