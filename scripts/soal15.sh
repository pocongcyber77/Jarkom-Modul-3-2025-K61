nano /var/www/html/index.php
isi : 
<?php
echo "<h1>Hostname: " . gethostname() . "</h1>";
// Tampilkan IP pengunjung (nanti akan diisi oleh header X-Real-IP)
$ip = $_SERVER['HTTP_X_REAL_IP'] ?? ($_SERVER['REMOTE_ADDR'] ?? 'unknown');
echo "<p>Your IP (as seen by PHP): " . htmlspecialchars($ip) . "</p>";
?>

/etc/init.d/php8.4-fpm restart
service nginx reload
