Aldarion
apt-get install isc-dhcp-server
nano /etc/default/isc-dhcp-server
isi : 
INTERFACESv4="eth0"


nano /etc/dhcp/dhcpd.conf
isi : 
  GNU nano 8.4                                                  /etc/dhcp/dhcpd.conf
# dhcpd.conf
#
# Sample configuration file for ISC dhcpd
#
# =====================================
# DHCP SERVER - Aldarion (Server Pusat)
# =====================================

# Default lease dan max lease akan disesuaikan lagi di soal no.6
default-lease-time 3600;   # 1 jam
max-lease-time 3600;

# DNS resolver awal (dari soal)
option domain-name-servers 192.168.122.1;

# ===================================================
# Subnet untuk KELUARGA MANUSIA (Dynamic Range)
# ===================================================
subnet 10.94.1.0 netmask 255.255.255.0 {
  range 10.94.1.6 10.94.1.34;
  range 10.94.1.68 10.94.1.94;
  option routers 10.94.1.1;     # router default keluarga manusia
  option broadcast-address 10.94.1.255;
}

# ===================================================
# Subnet untuk KELUARGA PERI (Dynamic Range)
# ===================================================
subnet 10.94.2.0 netmask 255.255.255.0 {
  range 10.94.2.35 10.94.2.67;
  range 10.94.2.96 10.94.2.121;
  option routers 10.94.2.1;
  option broadcast-address 10.94.2.255;
}

# ===================================================
# Subnet untuk KHAMUL (Fixed Address)
# ===================================================
subnet 10.94.3.0 netmask 255.255.255.0 {
  option routers 10.94.3.1;
  option broadcast-address 10.94.3.255;
}

# Host spesifik untuk Khamul
host khamul {
  hardware ethernet 02:42:fe:4b:1e:00;   # Ganti dengan MAC address Khamul
  fixed-address 10.94.3.95;
}

# ===================================================
# Subnet untuk SERVER PUSAT (interface eth0)
# ===================================================
subnet 10.94.4.0 netmask 255.255.255.0 {
}
service isc-dhcp-server stop
 service isc-dhcp-server restart
service isc-dhcp-server status

# DEBUGGING PROSES
dhcpd -d -cf /etc/dhcp/dhcpd.conf

Durin
 apt-get install isc-dhcp-relay -y
 nano /etc/default/isc-dhcp-relay
isi : 
# Defaults for isc-dhcp-relay initscript
# sourced by /etc/init.d/isc-dhcp-relay
# installed at /etc/default/isc-dhcp-relay by the maintainer scripts

#
# This is a POSIX shell fragment
#

# What servers should the DHCP relay forward requests to?
SERVERS="10.94.4.2"

# On what interfaces should the DHCP relay (dhrelay) serve DHCP requests?
INTERFACES="eth1 eth2 eth4"

# Additional options that are passed to the DHCP relay daemon?
OPTIONS=""

nano /etc/sysctl.conf
isi : 
net.ipv4.ip_forward=1
sysctl -p
service isc-dhcp-relay restart

