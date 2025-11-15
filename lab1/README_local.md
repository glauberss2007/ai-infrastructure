
## **Como usar:**

1. **Tornar os scripts executáveis:**
```bash
chmod +x *.sh
chmod +x verify-setup.py
```

2. **Executar configuração completa:**
```bash
./setup-all.sh
```

3. **Executar scripts individualmente:**
```bash
# Apenas drivers NVIDIA
./setup-nvidia.sh

# Apenas PyTorch
./setup-pytorch.sh

# Apenas verificação
python3 verify-setup.py
```

## **Script de Limpeza** (`cleanup.sh`)

```bash
#!/bin/bash

echo "🧹 LIMPANDO ARQUIVOS TEMPORÁRIOS"

# Remover instaladores baixados
rm -f cuda_*.run
rm -f miniconda.sh
rm -f NVIDIA-Linux-*.run

# Limpar cache pip
pip cache purge

# Limpar cache conda
conda clean -a -y

echo "✅ Limpeza concluída"
```

Estes scripts automatizam todo o processo! Eles verificam cada etapa e fornecem feedback claro sobre o progresso. 🚀