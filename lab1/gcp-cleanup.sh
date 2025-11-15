#!/bin/bash

INSTANCE_NAME="ai-gpu-instance"
ZONE="us-central1-a"

echo "🧹 LIMPANDO RECURSOS GCP"

# Deletar instância
echo "🗑️ Deletando instância..."
gcloud compute instances delete $INSTANCE_NAME --zone=$ZONE --quiet

# Limpar arquivos locais
rm -f gcp-post-setup.sh

echo "✅ Limpeza GCP concluída!"