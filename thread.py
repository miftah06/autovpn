#!/usr/bin/env python3
import subprocess

# Fungsi untuk menjalankan skrip dan membuat unit systemd
def install_and_create_systemd_unit(script_name, domain=None):
    # Jalankan skrip dengan subprocess
    subprocess.run(["chmod", "+x", script_name])  # Berikan izin eksekusi pada skrip
    if domain:
        subprocess.run(["./" + script_name, domain])
    else:
        subprocess.run(["./" + script_name])

    # Buat unit systemd untuk skrip yang dijalankan
    service_name = script_name.split('.')[0] + ".service"
    with open(f"/etc/systemd/system/{service_name}", "w") as unit_file:
        unit_file.write(f"""\
[Unit]
Description=Service for {script_name}
After=network.target

[Service]
ExecStart=/usr/bin/python3 {script_name} {domain}
Restart=always

[Install]
WantedBy=multi-user.target
""")

    # Reload daemon dan mulai layanan
    subprocess.run(["systemctl", "daemon-reload"])
    subprocess.run(["systemctl", "start", service_name])
    subprocess.run(["systemctl", "enable", service_name])

if __name__ == "__main__":
    # Meminta pengguna untuk memasukkan domain
    domain = input("Masukkan domain untuk verifikasi SSL: ")

    # Panggil fungsi untuk setiap skrip yang akan diinstal
    install_and_create_systemd_unit("port.sh")
    install_and_create_systemd_unit("all-tcp.sh")
    install_and_create_systemd_unit("udp-custom.py", domain)
