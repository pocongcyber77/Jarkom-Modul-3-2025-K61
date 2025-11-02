#!/bin/bash
PREFIX=10.94
DOMAIN=k61.com


if [[ $(hostname) == "Durin" ]]; then
  ip addr flush dev eth5
  ip addr add 10.94.5.129/26 dev eth5
  ip link set eth5 up
  echo 1 > /proc/sys/net/ipv4/ip_forward
fi


if [[ $(hostname) == "Minastir" ]]; then
  ip addr flush dev eth0
  ip addr add 10.94.5.130/26 dev eth0
  ip route add default via 10.94.5.129
fi


if [[ $(hostname) == "Palantir" ]]; then
  ip addr flush dev eth0
  ip addr add 10.94.3.11/26 dev eth0
  ip route add default via 10.94.3.1
fi


ping -c 2 10.94.5.129
ping -c 2 10.94.5.130
echo "✅ Soal 1 selesai - IP & routing dasar aktif"
