#!/bin/bash

echo "🚀 INICIANDO CONFIGURAÇÃO COMPLETA DA VM GPU"
echo "=============================================="

# Executar scripts em ordem
./setup-base.sh
./setup-nvidia.sh

# Após reboot, continuar com:
./setup-cuda.sh
./setup-conda.sh
./setup-python-env.sh
./setup-pytorch.sh

# Fazer verificações finais
python3 verify-setup.py

echo ""
echo "🎉 CONFIGURAÇÃO CONCLUÍDA!"
echo "Para usar o ambiente:"
echo "  conda activate ai"
echo "  jupyter lab"
echo ""
echo "Para verificar novamente: python3 verify-setup.py"