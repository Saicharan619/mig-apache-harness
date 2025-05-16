#!/bin/bash

# Log all output to a file for debugging
exec > /var/log/startup-script.log 2>&1
set -e

# Ensure required repos are enabled (important for CentOS 9)
dnf config-manager --set-enabled crb || true
dnf install -y dnf-utils || true

# Update system
dnf update -y

# Install Apache (httpd)
dnf install -y httpd

# Create sample HTML page
echo "<h1>Hello from MIG with Apache 🚀</h1>" > /var/www/html/index.html

# Enable and start Apache service
systemctl enable httpd
systemctl start httpd
