# tambah di nano /etc/bind/named.conf.local di Erendis
; CNAME
www     IN      CNAME   K28.com.

; TXT Records (Pesan Rahasia)
elros       IN      TXT     "Cincin Sauron"
pharazon    IN      TXT     "Aliansi Terakhir"

# update reverse zone nano /etc/bind/db.192.225.3 seperti ini
\$TTL 86400
@       IN      SOA     ns1.K28.com. admin.K28.com. (
                        2025110202
                        3600 1800 604800 86400 )
        IN      NS      ns1.K28.com.
        IN      NS      ns2.K28.com.

2       IN      PTR     ns1.K28.com.    ; 192.225.3.2
3       IN      PTR     ns2.K28.com.    ; 192.225.3.3

# Tambah baris ini kalau belum ada
echo 'zone "3.225.192.in-addr.arpa" { type master; file "/etc/bind/db.192.225.3"; allow-transfer { 192.225.3.3; }; };' >> /etc/bind/named.conf.local

systemctl restart bind9
systemctl enable bind9

# tes di Elendil
dig www.K28.com         
dig elros.K28.com TXT   
dig pharazon.K28.com TXT  
dig -x 192.225.3.2 @192.225.3.2   
dig -x 192.225.3.3 @192.225.3.3   