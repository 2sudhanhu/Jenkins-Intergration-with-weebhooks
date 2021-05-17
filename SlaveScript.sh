#!/bin/bash
sudo yum install jenkins java-1.8.0-openjdk-devel -y
sudo yum install git -y
sudo yum upgrade
sudo yum install httpd -y   
sudo chkconfig httpd on
sudo service httpd start
sudo service httpd enabled 