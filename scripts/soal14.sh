apt install apache2-utils
htpasswd -cb /etc/nginx/.htpasswd noldor silvan

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



service nginx reload

TES (node lain)
curl http://galadriel.k61.com:8004
curl -u noldor:silvan http://galadriel.k61.com:8004
