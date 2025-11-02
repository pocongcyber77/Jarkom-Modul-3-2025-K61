#!/bin/bash

DOMAIN=k61.com
PREFIX=10.94

if [[ $(hostname) == "Erendis" ]]; then
  cat > /etc/hosts <<EOF
127.0.0.1 localhost
${PREFIX}.3.2 erendis.${DOMAIN}
${PREFIX}.3.3 amdir.${DOMAIN}
${PREFIX}.3.11 palantir.${DOMAIN}
${PREFIX}.1.33 elros.${DOMAIN}
${PREFIX}.2.11 galadriel.${DOMAIN}
EOF
  echo "✅ Erendis DNS master siap (via /etc/hosts)"
fi

if [[ $(hostname) == "Amdir" ]]; then
  cp /etc/hosts /etc/hosts.bak
  cat /root/hosts_block_k61.txt >> /etc/hosts
  echo "✅ Amdir DNS slave siap (sinkron dari Erendis)"
fi
