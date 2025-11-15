#!/bin/bash

echo "=== INSTALANDO MINICONDA ==="

# Baixar e instalar Miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
bash miniconda.sh -b -p $HOME/miniconda

# Configurar PATH
echo 'export PATH="$HOME/miniconda/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Inicializar conda
$HOME/miniconda/bin/conda init bash
source ~/.bashrc

echo "✅ Miniconda instalado"