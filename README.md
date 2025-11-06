# Praktikum Jarkom Modul 3

# Soal 1 - 10
## Dikerjakan Oleh Ahmad Ibnu Athiallah - 5027241024

# Soal 1

1) Skrip utilitas global (jalankan di setiap host non-router sekali)

Salin & jalankan ini di setiap host non-router (Aldarion, Erendis, Amdir, Palantir, Narvi, Elros, Pharazon, Elendil, Isildur, Anarion, Galadriel, Celeborn, Oropher, Miriel, Amandil, Gilgalad, Celebrimbor, Khamul):

# Soal 12
Kerjakan di masing-masing node (galadriel, celeborn, oropher)

Contoh pengerjaan di Galadriel

1. `apt install -y nginx php8.4-fpm php8.4-cli`
2.
```
mkdir -p /var/www/html
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html
```
3. nano /var/www/html/index.php
```
<?php
echo "<h1>Hostname: " . gethostname() . "</h1>";
// Tampilkan IP pengunjung
$ip = $_SERVER['HTTP_X_REAL_IP'] ?? ($_SERVER['REMOTE_ADDR'] ?? 'unknown'); #yang ini untuk nomer 15
echo "<p>Your IP (as seen by PHP): " . htmlspecialchars($ip) . "</p>"; # ini untuk nomer 15
?>
```
4. `/etc/init.d/php8.4-fpm restart`

# Soal 13
Kerjakan di masing-masing node (galadriel, celeborn, oropher)

Melanjutkan di Galadriel

1. `nano /etc/nginx/sites-available/galadriel.k61.com`
```
# ISI DARI GALADRIEL K61.COM
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
```
2. 
```
ln -s /etc/nginx/sites-available/galadriel.k61.com /etc/nginx/sites-enabled/
service nginx start
```

### Tes dari Client
1. `nano /etc/hosts`
   `10.94.2.6   galadriel.k61.com #Tambahkan ini di line paling bawah`
2. `curl http://galadriel.k61.com:8004`

### Screenshor no. 12 dan 13
ss

# Soal 14
Kerjakan di masing-masing node (galadriel, celeborn, oropher)

Melanjutkan di node Galadriel

1. `apt install apache2-utils`
2. `htpasswd -cb /etc/nginx/.htpasswd noldor silvan`
3. `nano /etc/nginx/sites-available/galadriel.k61.com`
```
map $http_x_real_ip $real_ip_or_remote {
    ""      $remote_addr;
    default $http_x_real_ip;
}

server {
    listen 8004;
    server_name galadriel.k61.com;
    root /var/www/html;
    index index.php index.html index.htm;

    auth_basic "Restricted";
    auth_basic_user_file /etc/nginx/.htpasswd;

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
```
### Tes dari Node Client
curl http://galadriel.k61.com:8004

curl -u noldor:silvan http://galadriel.k61.com:8004
