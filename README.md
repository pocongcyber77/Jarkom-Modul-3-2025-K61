# Praktikum Jarkom Modul 3

# Soal 1 - 10
## Dikerjakan Oleh Ahmad Ibnu Athiallah - 5027241024

# Soal 1
Membuat topologi dan subnetting sesuai konfigurasi yang dibutuhkan di soal

# Soal 2
Subnetting dan set IP dinamis di beberapa node

<img width="809" height="405" alt="Screenshot 2025-11-07 045737" src="https://github.com/user-attachments/assets/50115b00-47cf-4b00-93ce-3197239e9829" />


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

### Screenshot no. 12 dan 13
<img width="906" height="68" alt="Screenshot 2025-11-07 050421" src="https://github.com/user-attachments/assets/e24907c0-df58-476b-9bbb-39364fa09dc6" />


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

<img width="773" height="211" alt="Screenshot 2025-11-07 050555" src="https://github.com/user-attachments/assets/149be54f-cb65-4ba4-82fa-3756ba50daaf" />

curl -u noldor:silvan http://galadriel.k61.com:8004

<img width="1381" height="90" alt="Screenshot 2025-11-07 050612" src="https://github.com/user-attachments/assets/9f105e63-7053-4f9d-8ab2-72cc5092774f" />


# Soal 15
Melanjutkan di Galadriel

`nano /var/www/html/index.php`
### Isinya
```
<?php
echo "<h1>Hostname: " . gethostname() . "</h1>";
// Tampilkan IP pengunjung (nanti akan diisi oleh header X-Real-IP)
$ip = $_SERVER['HTTP_X_REAL_IP'] ?? ($_SERVER['REMOTE_ADDR'] ?? 'unknown');
echo "<p>Your IP (as seen by PHP): " . htmlspecialchars($ip) . "</p>";
?>
```
`service nginx restart`

### Screenshot

<img width="1229" height="82" alt="Screenshot 2025-11-07 050828" src="https://github.com/user-attachments/assets/ec70b73a-3aeb-4db3-8c12-1f86d7b819a3" />

# Soal 16
(PHARAZON)

1. `apt install -y nginx`
2. 
```
nano /etc/hosts
10.94.2.6  galadriel.k61.com
10.94.2.4  pharazon.k61.com
//tambahkan untuk celeborn dan oropher
```
3.
```
nano /etc/nginx/sites-available/pharazon.k61.com
# === Upstream ke tiga worker PHP ===
upstream Kesatria_Lorien {
    server 10.94.2.6:8004;
    server 10.94.2.7:8005;
    server 10.94.2.8:8006;
}

server {
    listen 80;
    server_name pharazon.k61.com;

    # Blokir akses lewat IP langsung
    if ($host != 'pharazon.k61.com') {
        return 444;
    }

    location / {
        # Teruskan request ke backend PHP
        proxy_pass http://Kesatria_Lorien;

        # Header penting agar autentikasi diteruskan
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # === PENTING: teruskan Basic Auth ===
        proxy_pass_header Authorization;
        proxy_set_header Authorization $http_authorization;

        # Optional: timeout
        proxy_connect_timeout 10s;
        proxy_send_timeout 20s;
        proxy_read_timeout 20s;
    }

    access_log /var/log/nginx/pharazon.access.log;
    error_log  /var/log/nginx/pharazon.error.log;
}
```
4.
```
ln -s /etc/nginx/sites-available/pharazon.k61.com /etc/nginx/sites-enabled/
service nginx restart
```

### TES
<img width="1229" height="82" alt="Screenshot 2025-11-07 050828" src="https://github.com/user-attachments/assets/5b8ef665-3ede-4b6a-96de-e501b75ee807" />

