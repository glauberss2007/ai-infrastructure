#!/bin/bash

# Configurações
PROJECT_ID=$(gcloud config get-value project)
INSTANCE_NAME="ai-gpu-instance"
ZONE="us-central1-a"
INSTANCE_TYPE="n1-standard-8"
GPU_TYPE="nvidia-tesla-t4"
GPU_COUNT="1"

echo "🚀 INICIANDO CRIAÇÃO DA VM GPU NO GCP"

# Verificar se API está ativada
gcloud services enable compute.googleapis.com

# Criar instância
echo "🖥️ Criando instância GPU..."
gcloud compute instances create $INSTANCE_NAME \
    --zone=$ZONE \
    --machine-type=$INSTANCE_TYPE \
    --accelerator=type=$GPU_TYPE,count=$GPU_COUNT \
    --maintenance-policy=TERMINATE \
    --image-family=ubuntu-2204-lts \
    --image-project=ubuntu-os-cloud \
    --boot-disk-size=100GB \
    --boot-disk-type=pd-ssd \
    --metadata=startup-script='#!/bin/bash
        # Script de inicialização automática
        echo "⚙️ Instalando drivers NVIDIA..."
        sudo apt-get update
        sudo apt-get install -y ubuntu-drivers-common
        sudo ubuntu-drivers autoinstall
        
        echo "🔧 Instalando Miniconda..."
        wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
        bash miniconda.sh -b -p $HOME/miniconda
        echo "export PATH=\$HOME/miniconda/bin:\$PATH" >> $HOME/.bashrc
        source $HOME/.bashrc
        
        echo "🐍 Configurando ambiente Python..."
        $HOME/miniconda/bin/conda create -n ai python=3.10 -y
        $HOME/miniconda/bin/conda activate ai
        $HOME/miniconda/bin/pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
        $HOME/miniconda/bin/pip install jupyter pandas matplotlib
        
        echo "✅ Configuração automática concluída!"
    '

# Aguardar instância ficar pronta
echo "⏳ Aguardando instância ficar ready..."
sleep 60

# Obter IP externo
EXTERNAL_IP=$(gcloud compute instances describe $INSTANCE_NAME \
    --zone=$ZONE \
    --format='get(networkInterfaces[0].accessConfigs[0].natIP)')

echo "✅ Instância pronta! IP: $EXTERNAL_IP"

# Script de pós-configuração
cat > gcp-post-setup.sh << 'EOF'
#!/bin/bash

echo "🔧 Finalizando configuração GCP..."

# Instalar drivers (caso necessário)
sudo ubuntu-drivers autoinstall
sudo modprobe nvidia

# Verificar GPU
nvidia-smi

# Configurar conda no .bashrc
echo 'export PATH="$HOME/miniconda/bin:$PATH"' >> ~/.bashrc
echo 'source $HOME/miniconda/bin/activate ai' >> ~/.bashrc
source ~/.bashrc

# Verificação final
python3 - << 'PYEOF'
import torch
print("=== VERIFICAÇÃO GCP ===")
print(f"PyTorch: {torch.__version__}")
print(f"CUDA: {torch.cuda.is_available()}")
if torch.cuda.is_available():
    print(f"GPU: {torch.cuda.get_device_name(0)}")
    
    # Teste
    x = torch.rand(3000, 3000, device='cuda')
    y = torch.mm(x, x)
    print(f"Teste OK! Shape: {y.shape}")
PYEOF

# Configurar Jupyter
jupyter notebook --generate-config
echo "c.NotebookApp.ip = '0.0.0.0'" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.open_browser = False" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.port = 8888" >> ~/.jupyter/jupyter_notebook_config.py

echo "✅ Configuração GCP finalizada!"
EOF

# Executar pós-configuração
echo "🔧 Executando pós-configuração..."
gcloud compute scp gcp-post-setup.sh $INSTANCE_NAME:~ --zone=$ZONE
gcloud compute ssh $INSTANCE_NAME --zone=$ZONE --command="bash gcp-post-setup.sh"

echo ""
echo "🎉 CONFIGURAÇÃO GCP CONCLUÍDA!"
echo "📝 Comandos úteis:"
echo "   gcloud compute ssh $INSTANCE_NAME --zone=$ZONE"
echo "   nvidia-smi"
echo "   conda activate ai"
echo ""
echo "🧹 Para limpar: ./gcp-cleanup.sh"