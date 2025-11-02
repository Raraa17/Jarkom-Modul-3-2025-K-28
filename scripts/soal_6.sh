# Tanbah nano /etc/dhcp/dhcpd.conf di Aldarion
option domain-name-servers 192.225.4.2;

# Pool Manusia (30 menit)
default-lease-time 1800;
max-lease-time 3600;

# Pool peri (10 menit)
default-lease-time 600;
max-lease-time 3600;

systemctl restart isc-dhcp-server

# verifikasi di Aldarion
cat /var/lib/dhcp/dhcpd.leases | grep -i "lease\|ends"

# verfikasi di client dinamis
cat /var/lib/dhcp/dhclient.leases | grep -i "lease\|expire"
