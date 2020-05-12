#!/bin/bash

echo "Creating Nginx files..."
cat > influx.conf <<EOF
server {
    listen $1:443;
    server_name _;
    access_log off;

    location / {
        proxy_pass http://127.0.0.1:3000;
    }
}

server {
    listen $1:80;
    server_name _;
    access_log off;

    location / {
        proxy_pass http://127.0.0.1:3000;
    }
}
EOF
echo "Created influx.conf"

cat > default.conf <<EOF
server {
    listen      80;
    server_name $1;

    location / {
        root    /usr/share/nginx/html;
        index   index.html index.htm;
    }

    error_page  500 502 503 504     /50x.html;
    location = /50x.html {
        root    /usr/shar/nginx/html;
    }
}
EOF
echo "Created default.conf"