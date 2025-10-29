# KONFIGURASI
## KONFIG DURIN

### LANGKAH 0 — bersihkan file interfaces dulu
``` rm -f /etc/network/interfaces ```

### LANGKAH 1 — buat ulang /etc/network/interfaces
```
cat << 'EOF' > /etc/network/interfaces
auto lo
iface lo inet loopback

# NAT keluar internet GNS3
auto eth0
iface eth0 inet dhcp

# Subnet Laravel Worker
auto eth1
iface eth1 inet static
    address 10.15.43.1
    netmask 255.255.255.192

# Subnet PHP Worker
auto eth2
iface eth2 inet static
    address 10.15.43.65
    netmask 255.255.255.192

# Subnet Database
auto eth3
iface eth3 inet static
    address 10.15.43.129
    netmask 255.255.255.192

# Subnet Client
auto eth4
iface eth4 inet static
    address 10.15.43.193
    netmask 255.255.255.192
EOF
```
### LANGKAH 2 — Set DNS awal (buat install package)
``` echo "nameserver 192.168.122.1" > /etc/resolv.conf ```

### LANGKAH 3 — Restart node (WAJIB)
Karena container ini tidak punya reboot:

👉 di GNS3 GUI:

klik kanan Durin → Stop

klik kanan Durin → Start

buka Console lagi

### LANGKAH 4 — Cek hasilnya
```ip a show eth0```
Target IP harus seperti: ```inet 192.168.122.xxx/24```

### LANGKAH 5 — Test internet
```
ping -c 3 8.8.8.8
ping -c 3 google.com
```

### LANGKAH 6 — Enable IP forwarding
```echo 1 > /proc/sys/net/ipv4/ip_forward```

### LANGKAH 7 — NAT Masquerade
```iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE```

### LANGKAH 8 — Save rules agar tidak hilang
```
iptables-save > /etc/iptables.rules
```
#### buat startup loader:
```
cat << 'EOF' > /etc/rc.local
#!/bin/sh
iptables-restore < /etc/iptables.rules
exit 0
EOF
```
#### kasi ijin
``` chmod +x /etc/rc.local```

### 5. Install DHCP relay
```
apt update
apt install isc-dhcp-relay -y
```

"MANTAP.
SEMUA interface Durin sudah BENAR dan UP ✅✅✅

Rekap:

eth0 = 192.168.122.x (NAT internet) ✅

eth1 = 10.15.43.1/26 (Laravel workers) ✅

eth2 = 10.15.43.65/26 (PHP workers) ✅

eth3 = 10.15.43.129/26 (Databases) ✅

eth4 = 10.15.43.193/26 (Clients) ✅

Artinya:
Durin siap menjadi Router DHCP Relay.

## Lanjut CONFIG ALDARION (DHCP SERVER)"
### di durin
#### 1) Pindahkan IP gateway untuk Aldarion dari eth1 → eth4
```
ip addr del 10.15.43.1/26 dev eth1
ip addr add 10.15.43.1/26 dev eth4
```
cek
```ip a show eth4``` WAJIB ADA ```inet 10.15.43.1/26```

#### 2) NAT ulang (yang bener)
```iptables -t nat -A POSTROUTING -s 10.15.43.0/26 -o eth0 -j MASQUERADE```

#### 3) Aktifkan forward
```echo 1 > /proc/sys/net/ipv4/ip_forward```

#### Langkah di Aldarion
tambah default gateway
```ip route add default via 10.15.43.1```

#### Test (Dari Aldarion)
```ping -c 3 10.15.43.1```

#### Hapus default route yang salah
``` ip route del default```

ulang ```ip route add default via 10.15.43.1```

#### 4) TEST ALDARION
```
ping -c 3 10.15.43.1     # ping Durin
ping -c 3 8.8.8.8         # test internet
ping -c 3 google.com      # test DNS
```

#### 5. Kalau masih gagal ping 8.8.8.8
```
ip route del default
ip route add default via 10.15.43.1
```

##### jangan lupa test lagi

#### FIX DNS di ALDARION
```
echo "nameserver 8.8.8.8" > /etc/resolv.conf
```

