## **Como usar:**

1. **Configurar AWS CLI:**
```bash
aws configure
```

2. **Configurar Google Cloud:**
```bash
gcloud auth login
gcloud config set project SEU_PROJETO_ID
```

3. **Executar scripts:**
```bash
# AWS
chmod +x aws-gpu-setup.sh
./aws-gpu-setup.sh

# GCP
chmod +x gcp-gpu-setup.sh
./gcp-gpu-setup.sh

# Limpeza
./aws-cleanup.sh
./gcp-cleanup.sh
```

4. **Verificar instâncias:**
```bash
python3 cloud-verify.py
```

**Pré-requisitos:**
- AWS CLI instalado e configurado
- Google Cloud SDK instalado
- Cotas de GPU aprovadas nas clouds
- Credenciais de acesso configuradas

Estes scripts automatizam **100% do processo** desde a criação da VM até a configuração completa do ambiente de IA! 🚀