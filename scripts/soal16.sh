pharazon
apt install -y nginx
nano /etc/hosts
isi : 
10.94.2.6  galadriel.k61.com
10.94.2.4  pharazon.k61.com
//tambahkan untuk celeborn dan oropher

nano /etc/nginx/sites-available/pharazon.k61.com
isi : 
# === Upstream ke tiga worker PHP ===
upstream Kesatria_Lorien {
    server 10.94.2.6:8004;
#tambahkan node lainnya taman peri
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

 ln -s /etc/nginx/sites-available/pharazon.k61.com /etc/nginx/sites-enabled/
service nginx restart

curl -u noldor:silvan pharazon.k61.com

