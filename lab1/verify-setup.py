#!/usr/bin/env python3

import torch
import subprocess
import sys

def run_command(cmd):
    try:
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
        return result.stdout.strip()
    except Exception as e:
        return f"Erro: {e}"

print("=" * 50)
print("VERIFICAÇÃO DA CONFIGURAÇÃO GPU LOCAL")
print("=" * 50)

# Verificar GPU
print("\n🔍 VERIFICAÇÃO DA GPU:")
gpu_info = run_command("nvidia-smi --query-gpu=name,memory.total,driver_version --format=csv,noheader")
print(f"GPU Info: {gpu_info}")

# Verificar CUDA
print("\n⚡ VERIFICAÇÃO DO CUDA:")
cuda_version = run_command("nvcc --version | grep 'release'")
print(f"CUDA: {cuda_version}")

# Verificar PyTorch
print("\n🐍 VERIFICAÇÃO DO PYTORCH:")
print(f"PyTorch version: {torch.__version__}")
print(f"CUDA available: {torch.cuda.is_available()}")
print(f"CUDA version: {torch.version.cuda}")

if torch.cuda.is_available():
    device_count = torch.cuda.device_count()
    print(f"Number of GPUs: {device_count}")
    
    for i in range(device_count):
        print(f"GPU {i}: {torch.cuda.get_device_name(i)}")
        props = torch.cuda.get_device_properties(i)
        print(f"  Memory: {props.total_memory / 1e9:.1f} GB")
        print(f"  Compute Capability: {props.major}.{props.minor}")
    
    # Teste prático
    print("\n🧪 TESTE COMPUTACIONAL:")
    x = torch.rand(3000, 3000, device='cuda')
    y = torch.rand(3000, 3000, device='cuda')
    
    start = torch.cuda.Event(enable_timing=True)
    end = torch.cuda.Event(enable_timing=True)
    
    start.record()
    z = torch.mm(x, y)
    end.record()
    
    torch.cuda.synchronize()
    elapsed = start.elapsed_time(end)
    
    print(f"Multiplicação de matrizes 3000x3000: {elapsed:.2f} ms")
    print(f"Resultado shape: {z.shape}")
    print("✅ Teste concluído com sucesso!")
else:
    print("❌ GPU não detectada pelo PyTorch")

print("\n" + "=" * 50)