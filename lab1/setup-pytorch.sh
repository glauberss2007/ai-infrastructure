#!/bin/bash

echo "=== INSTALANDO PYTORCH E DEPENDÊNCIAS ==="

# Ativar ambiente
conda activate ai

# Instalar PyTorch com CUDA
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# Instalar bibliotecas essenciais de ML
pip install \
    numpy \
    pandas \
    matplotlib \
    seaborn \
    scikit-learn \
    jupyter \
    jupyterlab \
    ipykernel \
    pillow \
    opencv-python \
    transformers \
    datasets \
    tensorboard

# Registrar kernel do Jupyter
python -m ipykernel install --user --name=ai --display-name="Python (AI GPU)"

echo "✅ PyTorch e dependências instalados"