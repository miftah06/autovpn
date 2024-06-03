#!/usr/bin/env python3
import subprocess
import shutil
import os

# Fungsi untuk menjalankan skrip dan membuat unit systemd
def install_and_create_systemd_unit(script_name, domain=None):
    # Tentukan jalur tujuan untuk skrip
    destination = "/usr/bin/" + script_name

    # Pindahkan skrip jika itu adalah file .sh
    if script_name.endswith(".sh"):
        # Berikan izin eksekusi pada skrip sebelum memindahkannya
        subprocess.run(["chmod", "+x", script_name])
        if not os.path.exists(destination):
            shutil.move(script_name, destination)

    # Tentukan jalur eksekusi berdasarkan apakah skrip adalah file .sh atau tidak
    exec_start = destination if script_name.endswith(".sh") else f"/usr/bin/python3 /usr/bin/{script_name} {domain}"
    
    # Buat unit systemd untuk skrip yang dijalankan
    service_name = script_name.split('.')[0] + ".service"
    with open(f"/etc/systemd/system/{service_name}", "w") as unit_file:
        unit_file.write(f"""\
[Unit]
Description=Service for {script_name}
After=network.target

[Service]
ExecStart={exec_start}
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
