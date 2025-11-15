#!/bin/bash

echo "=== CRIANDO AMBIENTE PYTHON ==="

# Ativar conda
source ~/.bashrc

# Criar ambiente
conda create -n ai python=3.10 -y

# Ativar ambiente
conda activate ai

# Upgrade pip
pip install --upgrade pip

echo "✅ Ambiente Python criado"