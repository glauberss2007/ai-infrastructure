#!/bin/bash

# Configurações
KEY_NAME="ai-lab-key"
INSTANCE_NAME="ai-gpu-instance"
INSTANCE_TYPE="g5.xlarge"
SECURITY_GROUP="ai-lab-sg"
AMI_ID="ami-0a313d6098716f372"  # Deep Learning AMI GPU Ubuntu

echo "🚀 INICIANDO CRIAÇÃO DA VM GPU NA AWS"

# Criar key pair
echo "🔑 Criando key pair..."
aws ec2 create-key-pair \
    --key-name $KEY_NAME \
    --key-type rsa \
    --key-format pem \
    --query 'KeyMaterial' \
    --output text > $KEY_NAME.pem

chmod 400 $KEY_NAME.pem

# Criar security group
echo "🛡️ Criando security group..."
aws ec2 create-security-group \
    --group-name $SECURITY_GROUP \
    --description "Security group for AI lab"

# Adicionar regra SSH
aws ec2 authorize-security-group-ingress \
    --group-name $SECURITY_GROUP \
    --protocol tcp \
    --port 22 \
    --cidr $(curl -s ifconfig.me)/32

# Lançar instância
echo "🖥️ Lançando instância GPU..."
INSTANCE_ID=$(aws ec2 run-instances \
    --image-id $AMI_ID \
    --instance-type $INSTANCE_TYPE \
    --key-name $KEY_NAME \
    --security-groups $SECURITY_GROUP \
    --block-device-mappings '[{"DeviceName":"/dev/sda1","Ebs":{"VolumeSize":100,"VolumeType":"gp3"}}]' \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME}]" \
    --query 'Instances[0].InstanceId' \
    --output text)

echo "⏳ Instância $INSTANCE_ID criada, aguardando inicialização..."

# Aguardar instância ficar running
aws ec2 wait instance-running --instance-ids $INSTANCE_ID

# Obter IP público
PUBLIC_IP=$(aws ec2 describe-instances \
    --instance-ids $INSTANCE_ID \
    --query 'Reservations[0].Instances[0].PublicIpAddress' \
    --output text)

echo "✅ Instância pronta! IP: $PUBLIC_IP"

# Criar script de configuração automática
cat > aws-setup-commands.sh << 'EOF'
#!/bin/bash

echo "⚙️ Configurando ambiente na instância AWS..."

# Verificar GPU
nvidia-smi

# Atualizar conda environment
conda create -n ai python=3.10 -y
conda activate ai

# Instalar PyTorch
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# Instalar bibliotecas adicionais
pip install jupyter pandas matplotlib scikit-learn

# Configurar Jupyter
jupyter notebook --generate-config
echo "c.NotebookApp.ip = '0.0.0.0'" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.open_browser = False" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.port = 8888" >> ~/.jupyter/jupyter_notebook_config.py

# Script de verificação
python3 - << 'PYEOF'
import torch
print("=== VERIFICAÇÃO AWS ===")
print(f"PyTorch: {torch.__version__}")
print(f"CUDA: {torch.cuda.is_available()}")
if torch.cuda.is_available():
    print(f"GPU: {torch.cuda.get_device_name(0)}")
    
    # Teste performance
    import time
    start = time.time()
    x = torch.rand(5000, 5000, device='cuda')
    y = torch.rand(5000, 5000, device='cuda')
    z = torch.mm(x, y)
    elapsed = time.time() - start
    print(f"Performance: {elapsed:.2f}s para matriz 5000x5000")
PYEOF

echo "✅ Configuração AWS concluída!"
EOF

# Copiar script para instância
scp -i $KEY_NAME.pem -o StrictHostKeyChecking=no aws-setup-commands.sh ubuntu@$PUBLIC_IP:~

# Executar configuração remotamente
echo "🔧 Executando configuração automática..."
ssh -i $KEY_NAME.pem -o StrictHostKeyChecking=no ubuntu@$PUBLIC_IP 'bash aws-setup-commands.sh'

echo ""
echo "🎉 CONFIGURAÇÃO AWS CONCLUÍDA!"
echo "📝 Comandos úteis:"
echo "   ssh -i $KEY_NAME.pem ubuntu@$PUBLIC_IP"
echo "   nvidia-smi"
echo "   conda activate ai"
echo ""
echo "🧹 Para limpar: ./aws-cleanup.sh"