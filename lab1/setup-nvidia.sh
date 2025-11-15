#!/bin/bash

echo "=== INSTALANDO DRIVERS NVIDIA ==="

# Identificar e instalar driver recomendado
sudo ubuntu-drivers autoinstall

# Configurar blacklist do nouveau
sudo bash -c "echo 'blacklist nouveau' >> /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
sudo bash -c "echo 'options nouveau modeset=0' >> /etc/modprobe.d/blacklist-nvidia-nouveau.conf"

# Atualizar initramfs
sudo update-initramfs -u

echo "🔄 Reiniciando em 10 segundos para aplicar drivers..."
sleep 10
sudo reboot