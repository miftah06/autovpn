#!/bin/bash

# Fungsi untuk menambahkan pengguna baru
add_user() {
    username=$1
    password=$2
    # Implementasi penambahan pengguna baru
    sudo useradd -m -s /bin/bash $username
    echo "$username:$password" | sudo chpasswd
    echo "Pengguna baru berhasil ditambahkan: $username"
}

# Fungsi untuk menghapus pengguna
remove_user() {
    username=$1
    # Implementasi penghapusan pengguna
    sudo userdel -r $username
    echo "Pengguna berhasil dihapus: $username"
}

# Fungsi untuk memblokir akses pengguna
block_user() {
    username=$1
    # Implementasi pemblokiran pengguna
    sudo passwd -l $username
    echo "Akses pengguna berhasil diblokir: $username"
}

# Fungsi untuk membuka akses pengguna yang diblokir
unblock_user() {
    username=$1
    # Implementasi membuka blokir akses pengguna
    sudo passwd -u $username
    echo "Akses pengguna berhasil dibuka: $username"
}

# Fungsi untuk mengatur konfigurasi server
configure_server() {
    # Implementasi konfigurasi server sesuai kebutuhan
    # Misalnya, konfigurasi firewall, DNS, atau SSH
    echo "Konfigurasi server berhasil diatur"
}

# Fungsi untuk mengelola akses VPN
manage_vpn_access() {
    # Implementasi manajemen akses VPN
    # Misalnya, menambah atau menghapus pengguna VPN
    echo "Manajemen akses VPN berhasil dilakukan"
}

# Fungsi untuk memblokir akses ke situs web
block_website() {
    website=$1
    # Implementasi pemblokiran situs web
    # Misalnya, menggunakan iptables atau file hosts
    sudo echo "127.0.0.1 $website" >> /etc/hosts
    echo "Akses ke situs web berhasil diblokir: $website"
}

# Fungsi untuk membuka blokir akses ke situs web
unblock_website() {
    website=$1
    # Implementasi membuka blokir akses situs web
    # Misalnya, dengan menghapus entri dari iptables atau file hosts
    sudo sed -i "/$website/d" /etc/hosts
    echo "Akses ke situs web berhasil dibuka: $website"
}

# Fungsi untuk merestart semua layanan
restart_all_services() {
    # Implementasi restart semua layanan
    sudo systemctl restart --all
    echo "Semua layanan berhasil direstart"
}

# Fungsi untuk menyalakan VPN menggunakan proxychains4
start_vpn() {
    # Implementasi menyalakan VPN dengan proxychains4
    sudo proxychains4 systemctl restart xray && sudo proxychains4 systemctl restart nginx &
    sleep 5  # Tunggu beberapa saat untuk VPN terhubung
    ip_address=$(curl -s ifconfig.me)
    echo "VPN telah aktif. IP saat ini: $ip_address"
}

# Pilihan menu
menu() {
    clear
    echo "Menu:"
    echo "1. Tambah Pengguna"
    echo "2. Hapus Pengguna"
    echo "3. Blokir Pengguna"
    echo "4. Buka Blokir Pengguna"
    echo "5. Konfigurasi Server"
    echo "6. Kelola Akses VPN"
    echo "7. Blokir Situs Web"
    echo "8. Buka Blokir Situs Web"
    echo "9. Restart Semua Layanan"
    echo "10. Aktifkan VPN"
    echo "11. Keluar"
}

# Main program
while true; do
    menu
    read -p "Pilihan: " choice
    case $choice in
        1)  read -p "Username: " username
            read -p "Password: " -s password
            add_user $username $password
            ;;
        2)  read -p "Username: " username
            remove_user $username
            ;;
        3)  read -p "Username: " username
            block_user $username
            ;;
        4)  read -p "Username: " username
            unblock_user $username
            ;;
        5)  configure_server
            ;;
        6)  manage_vpn_access
            ;;
        7)  read -p "Website: " website
            block_website $website
            ;;
        8)  read -p "Website: " website
            unblock_website $website
            ;;
        9)  restart_all_services
            ;;
        10) start_vpn
            ;;
        11) break
            ;;
        *)  echo "Pilihan tidak valid!"
            ;;
    esac
    read -p "Tekan Enter untuk melanjutkan..."
done
