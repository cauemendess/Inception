#!/bin/bash

set -e

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

echo "� Instalando Docker Compose..."
# Instala a versão mais recente do Docker Compose
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')
sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Cria link simbólico para usar sem sudo
sudo ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose

echo "�👤 Adicionando o usuário '$USER' ao grupo 'docker'..."
sudo usermod -aG docker $USER

echo "🔧 Configurando permissões sudo para Docker..."
# Adiciona regra no sudoers para permitir comandos Docker sem senha
echo "$USER ALL=(ALL) NOPASSWD: /usr/bin/docker, /usr/bin/docker-compose" | \
    sudo tee /etc/sudoers.d/docker-$USER > /dev/null

# Garante que o arquivo tem as permissões corretas
sudo chmod 440 /etc/sudoers.d/docker-$USER

echo "🚀 Habilitando e iniciando o serviço Docker..."
sudo systemctl enable docker
sudo systemctl start docker

echo "🔄 Aplicando permissões do grupo docker..."
# Aplica as permissões do grupo imediatamente
sudo newgrp docker << EOF
echo "Permissões aplicadas!"
EOF

echo "✅ Instalação concluída!"
echo "🐳 Docker instalado e configurado com permissões sudo!"
echo "ℹ️ Você pode usar 'sudo docker' sem senha ou reiniciar para usar 'docker' diretamente."
