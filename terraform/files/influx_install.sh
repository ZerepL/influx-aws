#!/bin/bash

sudo apt update

sudo apt install nginx -y
sudo apt-get install -y adduser libfontconfig1

wget https://dl.influxdata.com/influxdb/releases/influxdb_1.8.0_amd64.deb
wget https://dl.influxdata.com/chronograf/releases/chronograf_1.8.4_amd64.deb
wget https://dl.grafana.com/oss/release/grafana_6.7.3_amd64.deb

sudo dpkg -i influxdb_1.8.0_amd64.deb
sudo dpkg -i chronograf_1.8.4_amd64.deb
sudo dpkg -i grafana_6.7.3_amd64.deb

rm *.deb

sudo mv influx.conf /etc/nginx/conf.d/
sudo mv default.conf /etc/nginx/conf.d/
sudo mv /tmp/influxdb.conf /etc/influxdb/

sudo systemctl start influxdb
sudo systemctl start grafana-server
sudo systemctl stop chronograf
sudo systemctl restart nginx
