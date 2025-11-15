#!/bin/bash

echo "=== INSTALANDO CUDA TOOLKIT ==="

# Versão do CUDA (ajuste conforme necessidade)
CUDA_VERSION="12.2"
CUDA_INSTALLER="cuda_12.2.0_535.54.03_linux.run"

# Baixar CUDA
wget https://developer.download.nvidia.com/compute/cuda/12.2.0/local_installers/$CUDA_INSTALLER

# Dar permissão e instalar (sem driver)
chmod +x $CUDA_INSTALLER
sudo sh $CUDA_INSTALLER --toolkit --silent --override

# Configurar environment variables
echo "export PATH=/usr/local/cuda/bin:\$PATH" >> ~/.bashrc
echo "export LD_LIBRARY_PATH=/usr/local/cuda/lib64:\$LD_LIBRARY_PATH" >> ~/.bashrc
echo "export CUDA_HOME=/usr/local/cuda" >> ~/.bashrc

# Recarregar bashrc
source ~/.bashrc

echo "✅ CUDA Toolkit instalado"