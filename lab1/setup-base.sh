#!/bin/bash

echo "=== CONFIGURAÇÃO BASE DA VM COM GPU ==="

# Atualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar dependências do sistema
sudo apt install -y \
    build-essential \
    curl \
    wget \
    git \
    vim \
    htop \
    nvtop \
    cmake \
    pkg-config \
    libssl-dev \
    software-properties-common

# Adicionar repositório de drivers NVIDIA
sudo add-apt-repository ppa:graphics-drivers/ppa -y
sudo apt update

echo "✅ Configuração base concluída"