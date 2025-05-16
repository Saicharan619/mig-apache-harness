#!/bin/bash
apt update
apt install -y apache2
echo "<h1>Hello from MIG with Apache! 🚀</h1>" > /var/www/html/index.html
systemctl enable apache2
systemctl start apache2
