apt install -y nginx php8.4-fpm php8.4-cli

start php : 
/etc/init.d/php8.4-fpm start

mkdir -p /var/www/html
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

nano /var/www/html/index.php
isi : 
<?php
// Tampilkan nama host (hostname)
echo "<h1>Selamat datang di taman digital " . gethostname() . "</h1>";
?>

/etc/init.d/php8.4-fpm restart
nano /etc/nginx/sites-available/galadriel.k61.com
isi : 
map $http_x_real_ip $real_ip_or_remote {
    ""      $remote_addr;
    default $http_x_real_ip;
}

server {
    listen 8004;
    server_name galadriel.k61.com;
    root /var/www/html;
    index index.php index.html index.htm;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.4-fpm.sock;
        fastcgi_param HTTP_X_REAL_IP $remote_addr;
    }

    location ~ /\.ht {
        deny all;
    }
}

ln -s /etc/nginx/sites-available/galadriel.k61.com /etc/nginx/sites-enabled/
nginx -t
service reload nginx

TES (client node)
nano /etc/hosts
isi : 
10.94.2.6   galadriel.k61.com

curl http://galadriel.k61.com:8004
