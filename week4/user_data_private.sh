#!/bin/bash -xe
sudo yum update -y
sudo yum install httpd -y
sudo service httpd start
sudo chkconfig httpd on
sudo sh -c 'echo "<html><h1>This is WebServer from private subnet</h1></html>" > /var/www/html/index.html'
