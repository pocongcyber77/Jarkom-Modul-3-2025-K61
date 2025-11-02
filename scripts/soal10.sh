#!/bin/bash

TARGET=http://elros.k61.com/api/airing/
if command -v ab >/dev/null; then
  ab -n 100 -c 10 $TARGET > /root/ab_initial.txt
  ab -n 2000 -c 100 $TARGET > /root/ab_full.txt
else
  echo "ab tidak tersedia; gunakan simulasi curl"
  seq 1 100 | xargs -P10 -I{} curl -s $TARGET >/dev/null
  echo "Simulasi benchmark selesai"
fi
echo "✅ Soal 10 selesai (log di /root/)"
