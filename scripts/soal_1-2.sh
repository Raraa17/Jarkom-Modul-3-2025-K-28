#Soal 1
#Pada node selain Durin
ping 8.8.8.8 
ping google.com

#Soal 2
#Aldarion
apt update
apt install -y isc-dhcp-server

#di nano /etc/dhcp/dhcpd.conf:
option domain-name "K28.com";  
option domain-name-servers 192.168.122.1;  
default-lease-time 1800;    
max-lease-time 3600;       
authoritative;

# Manusia
subnet 192.225.1.0 netmask 255.255.255.0 {
    pool {
        range 192.225.1.6 192.225.1.34;
        range 192.225.1.68 192.225.1.94;
        option routers 192.225.1.1;
        option broadcast-address 192.225.1.255;
        default-lease-time 1800;
        max-lease-time 3600;
    }
}

# Peri
subnet 192.225.2.0 netmask 255.255.255.0 {
    pool {
        range 192.225.2.35 192.225.2.67;
        range 192.225.2.96 192.225.2.121;
        option routers 192.225.2.1;
        option broadcast-address 192.225.2.255;
        default-lease-time 600;   
        max-lease-time 3600;
    }
}

subnet 192.225.3.0 netmask 255.255.255.0 {
}

subnet 192.225.4.0 netmask 255.255.255.0 {
}

subnet 192.225.5.0 netmask 255.255.255.0 {
}

host Khamul {
    hardware ethernet 02:42:c5:0d:e0:00; 
    fixed-address 192.225.3.95;
}

# ubah nano /etc/default/isc-dhcp-server:
INTERFACESv4="eth0"

service isc-dhcp-server restart

# Durin
apt install -y isc-dhcp-relay

# Ubah nano /etc/default/isc-dhcp-relay
SERVERS="192.225.4.2"  # IP Aldarion (DHCP Server)

INTERFACES="eth1 eth2 eth3 eth4 eth5"

service isc-dhcp-relay restart

# Terus ganti konfigurasi setiap client dinamis (Amandil dan Gilgalad), lebih baik taruh di script bukan edit langsung (bash /root/startup.sh)
auto eth0
iface eth0 inet dhcp
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf

#terus jalanin: (pastiin ifupdown udah terinstall sebelum flush)
ip addr flush dev eth0
ifdown eth0; ifup eth0

# selanjutnya tes dhcp di client dinamis:
ping 8.8.8.8

# cek juga di khamul setelah kita set MAC di Aldarion:
ifup eth0
ip a  # Harus: 192.225.3.95
