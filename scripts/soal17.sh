apt install apache2-utils -y
ab -n 1000 -c 100 -A noldor:silvan http://pharazon.k61.com
cat pharazon_access.log | tail;
service nginx stop

