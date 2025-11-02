#ministir
apt update
apt install -y unbound

nano /etc/unbound/unbound.conf:
server:
    interface: 0.0.0.0
    port: 53
    do-ip4: yes
    do-udp: yes
    do-tcp: yes
    access-control: 192.225.0.0/16 allow
    access-control: 0.0.0.0/0 refuse
    hide-identity: yes
    hide-version: yes
    cache-min-ttl: 300
    cache-max-ttl: 86400

forward-zone:
    name: "."
    forward-addr: 192.168.122.1


systemctl restart unbound
systemctl enable unbound

#Tambah di config node static
dns-nameservers 192.225.4.2

#Tambah di dalam setiap pool di Aldarion
option domain-name-servers 192.225.4.2;

# cek apakah nameserver 192.225.4.2
cat /etc/resolv.conf
ping google.com
