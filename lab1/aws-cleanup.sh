#!/bin/bash

INSTANCE_NAME="ai-gpu-instance"
KEY_NAME="ai-lab-key"
SECURITY_GROUP="ai-lab-sg"

echo "🧹 LIMPANDO RECURSOS AWS"

# Obter ID da instância
INSTANCE_ID=$(aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=$INSTANCE_NAME" \
    --query 'Reservations[0].Instances[0].InstanceId' \
    --output text)

if [ "$INSTANCE_ID" != "None" ]; then
    echo "🗑️ Terminando instância: $INSTANCE_ID"
    aws ec2 terminate-instances --instance-ids $INSTANCE_ID
    aws ec2 wait instance-terminated --instance-ids $INSTANCE_ID
fi

# Deletar key pair
echo "🗑️ Deletando key pair..."
aws ec2 delete-key-pair --key-name $KEY_NAME
rm -f $KEY_NAME.pem

# Deletar security group
echo "🗑️ Deletando security group..."
aws ec2 delete-security-group --group-name $SECURITY_GROUP 2>/dev/null || true

# Limpar arquivos locais
rm -f aws-setup-commands.sh

echo "✅ Limpeza AWS concluída!"