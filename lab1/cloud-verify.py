#!/usr/bin/env python3

import subprocess
import torch

def run_ssh_command(ip, key_file, command):
    """Executa comando via SSH"""
    try:
        cmd = f"ssh -i {key_file} -o StrictHostKeyChecking=no ubuntu@{ip} '{command}'"
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
        return result.stdout.strip()
    except Exception as e:
        return f"Erro: {e}"

def verify_aws():
    """Verifica instância AWS"""
    print("=== VERIFICAÇÃO AWS ===")
    # Obter IP da instância (você precisará configurar isso)
    aws_ip = "SEU_IP_AWS_AQUI"  # Substitua pelo IP real
    key_file = "ai-lab-key.pem"
    
    if aws_ip != "SEU_IP_AWS_AQUI":
        gpu_info = run_ssh_command(aws_ip, key_file, "nvidia-smi --query-gpu=name --format=csv,noheader")
        pytorch_info = run_ssh_command(aws_ip, key_file, "conda activate ai && python -c \"import torch; print(f'PyTorch {torch.__version__}, CUDA: {torch.cuda.is_available()}')\"")
        
        print(f"GPU: {gpu_info}")
        print(f"PyTorch: {pytorch_info}")
    else:
        print("Configure o IP da instância AWS no script")

def verify_gcp():
    """Verifica instância GCP"""
    print("\n=== VERIFICAÇÃO GCP ===")
    try:
        # Obter IP da instância GCP
        result = subprocess.run(
            "gcloud compute instances describe ai-gpu-instance --zone=us-central1-a --format='get(networkInterfaces[0].accessConfigs[0].natIP)'",
            shell=True, capture_output=True, text=True
        )
        gcp_ip = result.stdout.strip()
        
        if gcp_ip:
            gpu_info = subprocess.run(
                f"gcloud compute ssh ai-gpu-instance --zone=us-central1-a --command='nvidia-smi --query-gpu=name --format=csv,noheader'",
                shell=True, capture_output=True, text=True
            )
            print(f"GPU: {gpu_info.stdout.strip()}")
            print("Instância GCP configurada com sucesso!")
        else:
            print("Instância GCP não encontrada")
    except Exception as e:
        print(f"Erro na verificação GCP: {e}")

if __name__ == "__main__":
    verify_aws()
    verify_gcp()