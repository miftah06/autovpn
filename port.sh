#!/bin/bash

# Fungsi untuk menampilkan baris pemisah ganda
msg_bar2() {
    echo "============================================================"
}

# Fungsi untuk menampilkan pesan dan melanjutkan jika kondisi terpenuhi
msg_and() {
    if [[ "$1" == "import" ]]; then
        echo "File berhasil diimpor."
    fi
}

# Mengatur port Apache ke 81
sed -i "s/Listen 80/Listen 81/g" /etc/apache2/ports.conf
service apache2 restart

# Install Webmin
echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list
wget -qO- http://www.webmin.com/jcameron-key.asc | apt-key add -
apt-get update
apt-get install webmin -y

# Install XRay dengan VMess dan VLess
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" --install xray

# Install Trojan
wget -O /usr/local/bin/trojan-go https://github.com/p4gefau1t/trojan-go/releases/latest/download/trojan-go-linux-amd64.zip
unzip /usr/local/bin/trojan-go
chmod +x /usr/local/bin/trojan-go

# Install Nginx
apt-get install nginx -y

# Input domain
read -p "Masukkan domain Anda (contoh: example.com): " domain

# Membuat sertifikat SSL
certbot certonly --nginx -d $domain --non-interactive --agree-tos --email your_email@example.com

# Konfigurasi Nginx untuk WebSocket dan SSL
cat <<EOF > /etc/nginx/sites-available/default
server {
    listen 443 ssl http2;
    server_name $domain;

    ssl_certificate /etc/letsencrypt/live/$domain/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$domain/privkey.pem;

    location / {
        proxy_pass http://127.0.0.1:10000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$http_host;
    }
}

server {
    listen 4443 ssl http2;
    server_name $domain;

    ssl_certificate /etc/letsencrypt/live/$domain/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$domain/privkey.pem;

    location /vless {
        proxy_pass http://127.0.0.1:10001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$http_host;
    }
}
EOF

# Install IPsec
apt-get install strongswan -y

# Install SSTP
apt-get install sstp-server -y

# Install DDoS Deflate
apt-get install dos2unix -y
wget -O /usr/local/sbin/ddos.sh https://github.com/jgmdev/ddos-deflate/raw/master/ddos.sh
chmod +x /usr/local/sbin/ddos.sh

# Install Fail2Ban
apt-get install fail2ban -y

# Install TCPSpeed
apt-get install python3-pip -y
pip3 install tcp_speed_test

# Install VPN blocker lainnya (disesuaikan dengan kebutuhan)

# Menampilkan baris pemisah ganda
msg_bar2

# Menampilkan pesan dan melanjutkan jika kondisi terpenuhi
msg_and import
