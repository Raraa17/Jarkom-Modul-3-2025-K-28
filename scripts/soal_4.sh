# Di Erendis & Amdir
apt update
apt install -y bind9 bind9utils

# ubah nano /etc/bind/named.conf.local di Erendis
// ZONE K28.com (MASTER)
zone "K28.com" {
    type master;
    file "/etc/bind/db.K28.com";
    allow-transfer { 192.225.3.3; };  // IP Amdir
};

// REVERSE ZONES (MASTER)
zone "1.225.192.in-addr.arpa" { type master; file "/etc/bind/db.192.225.1"; allow-transfer { 192.225.3.3; }; };
zone "2.225.192.in-addr.arpa" { type master; file "/etc/bind/db.192.225.2"; allow-transfer { 192.225.3.3; }; };
zone "3.225.192.in-addr.arpa" { type master; file "/etc/bind/db.192.225.3"; allow-transfer { 192.225.3.3; }; };
zone "4.225.192.in-addr.arpa" { type master; file "/etc/bind/db.192.225.4"; allow-transfer { 192.225.3.3; }; };
zone "5.225.192.in-addr.arpa" { type master; file "/etc/bind/db.192.225.5"; allow-transfer { 192.225.3.3; }; };
EOF

# ubah nano /etc/bind/db.K28.com
\$TTL 86400
@       IN      SOA     ns1.K28.com. admin.K28.com. (
                        2025110201 ; Serial
                        3600       ; Refresh
                        1800       ; Retry
                        604800     ; Expire
                        86400 )    ; Minimum TTL
        IN      NS      ns1.K28.com.
        IN      NS      ns2.K28.com.

; NS Records
ns1     IN      A       192.225.3.2     ; Erendis
ns2     IN      A       192.225.3.3     ; Amdir

; A Records
palantir    IN      A       192.225.4.10
elros       IN      A       192.225.4.11
pharazon    IN      A       192.225.4.12
elendil     IN      A       192.225.1.2
isildur     IN      A       192.225.1.3
anarion     IN      A       192.225.1.4
galadriel   IN      A       192.225.2.2
celeborn    IN      A       192.225.2.3
oropher     IN      A       192.225.2.4

# buar reverse zone nano etc/bind/db.192.225.1
\$TTL 86400
@       IN      SOA     ns1.K28.com. admin.K28.com. (
                        2025110201
                        3600 1800 604800 86400 )
        IN      NS      ns1.K28.com.
        IN      NS      ns2.K28.com.

1       IN      PTR     durin.K28.com.
2       IN      PTR     elendil.K28.com.
3       IN      PTR     isildur.K28.com.
4       IN      PTR     anarion.K28.com.

# ubah nano /etc/bind/named.conf.local di Amdir
zone "K28.com" {
    type slave;
    file "/var/cache/bind/db.K28.com";
    masters { 192.225.3.2; };  // IP Erendis
};

zone "1.225.192.in-addr.arpa" { type slave; file "/var/cache/bind/db.192.225.1"; masters { 192.225.3.2; }; };
zone "2.225.192.in-addr.arpa" { type slave; file "/var/cache/bind/db.192.225.2"; masters { 192.225.3.2; }; };
zone "3.225.192.in-addr.arpa" { type slave; file "/var/cache/bind/db.192.225.3"; masters { 192.225.3.2; }; };
zone "4.225.192.in-addr.arpa" { type slave; file "/var/cache/bind/db.192.225.4"; masters { 192.225.3.2; }; };
zone "5.225.192.in-addr.arpa" { type slave; file "/var/cache/bind/db.192.225.5"; masters { 192.225.3.2; }; };

# jalankan
mkdir -p /var/cache/bind
chown bind:bind /var/cache/bind

# di Erendis & Amdir
pkill named
named -c /etc/bind/named.conf -g   

# kalau udah aman:
pkill named
named -c /etc/bind/named.conf &
echo $! > /var/run/named.pid

# tes dii Elendil
dig @192.225.3.2 elendil.K28.com   
dig @192.225.3.3 elendil.K28.com     
dig -x 192.225.1.2 @192.225.3.2      