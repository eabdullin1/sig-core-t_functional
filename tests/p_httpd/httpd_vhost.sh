#!/bin/sh
# Author: Athmane Madjoudj <athmanem@gmail.com>

t_Log "Running $0 - httpd virtual host test."

echo "127.0.0.1   test" >>  /etc/hosts
cat > /etc/httpd/conf.d/vhost-test.conf <<EOF
NameVirtualHost *:80

<VirtualHost *:80>
 ServerAdmin webmaster@test
 DocumentRoot /var/www/vhosts/test/
 ServerName test
</VirtualHost>
EOF

mkdir -p /var/www/vhosts/test/
echo "Virtual Host Test Page" > /var/www/vhosts/test/index.html
t_ServiceControl httpd reload
echo -e "GET / HTTP/1.0\r\n" | nc test 80 | grep 'Virtual Host Test Page'

t_CheckExitStatus $?

# SteveCB: remove vhost-test.conf to prevent later tests 
# that assume DocumentRoot is /var/www/html from failing
rm /etc/httpd/conf.d/vhost-test.conf
t_ServiceControl httpd reload