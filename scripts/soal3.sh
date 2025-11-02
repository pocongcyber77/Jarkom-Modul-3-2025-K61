#!/bin/bash

PREFIX=10.94
cat > /root/alloc.sh <<'EOF'
#!/bin/bash
NAME=$1; RACE=$2; TYPE=$3
PREFIX=10.94
if [[ $TYPE == "fixed" && $NAME == "Khamul" ]]; then
  IP="${PREFIX}.3.95"
  echo "$NAME,$IP,$RACE,$TYPE" >> /root/dhcp_allocations.txt
  echo "$IP"
  exit
fi

if [[ $RACE == "human" ]]; then
  A=$(shuf -i 6-94 -n1)
  IP="${PREFIX}.1.$A"
else
  A=$(shuf -i 35-121 -n1)
  IP="${PREFIX}.2.$A"
fi
echo "$NAME,$IP,$RACE,$TYPE" >> /root/dhcp_allocations.txt
echo "$IP"
EOF
chmod +x /root/alloc.sh
touch /root/dhcp_allocations.txt
echo " DHCP Allocator siap (jalankan: ./alloc.sh <nama> <ras> <tipe>)"
