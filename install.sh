#!/bin/bash

set -e  # Encerra o script se algum comando falhar

echo "🔄 Atualizando pacotes..."
sudo apt update
sudo apt upgrade -y

echo "📦 Instalando dependências para o Docker..."
sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    gnupg \
    lsb-release \
    make

echo "🔑 Adicionando chave GPG oficial do Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /usr/share/keyrings/docker.gpg

echo "➕ Adicionando repositório do Docker à lista de fontes..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "🔄 Atualizando pacotes novamente..."
sudo apt update

echo "🐳 Instalando Docker..."
sudo apt install -y docker-ce docker-ce-cli containerd.io

echo "👤 Adicionando o usuário '$USER' ao grupo 'docker'..."
sudo usermod -aG docker $USER

echo "✅ Instalação concluída!"
echo "⚠️ Reinicie a VM ou faça logout/login para ativar o uso do Docker sem sudo."
