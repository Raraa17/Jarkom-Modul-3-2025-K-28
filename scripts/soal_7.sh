# di Elendil/Isildur/Anarion
apt update
apt install -y nginx lynx curl git unzip software-properties-common ca-certificates lsb-release apt-transport-https

wget -qO - https://packages.sury.org/php/README.txt | grep -oP 'signed-by.*' | cut -d' ' -f3 > /etc/apt/trusted.gpg.d/php.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list
apt update

apt install -y php8.4 php8.4-fpm php8.4-mysql php8.4-mbstring php8.4-xml php8.4-zip php8.4-curl php8.4-bcmath php8.4-intl

curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

cd /var/www
git clone https://github.com/elshiraphine/laravel-simple-rest-api.git .

chown -R www-data:www-data /var/www
cd /var/www
composer install --no-dev --optimize-autoloader
cp .env.example .env

# ubah nano /etc/nginx/sites-available/elendil
server {
    listen 80;
    server_name elendil.K28.com;
    root /var/www/public;
    index index.php index.html;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php\$ {
        fastcgi_pass unix:/run/php/php8.4-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    }

    # Hanya via domain, bukan IP
    if (\$host != 'elendil.K28.com') {
        return 403;
    }
}

# ubah /etc/nginx/sites-available/isildur
server {
    listen 80;
    server_name isildur.K28.com;
    root /var/www/public;
    index index.php index.html;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php\$ {
        fastcgi_pass unix:/run/php/php8.4-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    }

    if (\$host != 'isildur.K28.com') {
        return 403;
    }

ln -s /etc/nginx/sites-available/isildur /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default


# ubah nano /etc/nginx/sites-available/anarion
server {
    listen 80;
    server_name anarion.K28.com;
    root /var/www/public;
    index index.php index.html;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php\$ {
        fastcgi_pass unix:/run/php/php8.4-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    }

    if (\$host != 'anarion.K28.com') {
        return 403;
    }
}

ln -s /etc/nginx/sites-available/anarion /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default

# lalu start service di Elendil/Isildur/Anarion
systemctl restart nginx php8.4-fpm
systemctl enable nginx php8.4-fpm

# test config
nginx -t
php8.4 -v  
composer --version

# tes
lynx http://elendil.K28.com
lynx http://isildur.K28.com
lynx http://anarion.K28.com