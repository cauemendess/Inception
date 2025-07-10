#!/bin/bash

# Criar diretório se não existir
mkdir -p /var/www/html
cd /var/www/html

# Adicionar domínio ao /etc/hosts do container para resolução local
echo "127.0.0.1 ${DOMAIN_NAME}" >> /etc/hosts

# Aguardar MariaDB estar pronto
echo "Aguardando MariaDB estar pronto..."
until mysqladmin ping -h ${WORDPRESS_DB_HOST} --silent; do
    echo "Tentando conectar ao MariaDB em ${WORDPRESS_DB_HOST}..."
    sleep 3
done
echo "MariaDB está pronto!"

echo "Baixando WordPress..."
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar

echo "Configurando WordPress..."
./wp-cli.phar core download --allow-root
./wp-cli.phar config create --dbname=${MYSQL_DATABASE} --dbuser=${MYSQL_USER} --dbpass=${MYSQL_PASSWORD} --dbhost=${WORDPRESS_DB_HOST} --allow-root

echo "Instalando WordPress..."
if ! ./wp-cli.phar core install --url=https://${DOMAIN_NAME} --title="${WP_TITLE}" --admin_user=${WP_ADMIN} --admin_password=${WP_ADMIN_PASS} --admin_email=${WP_ADMIN_EMAIL} --allow-root; then
    echo "ERRO: Falha na instalação do WordPress!"
    echo "Verificando variáveis:"
    echo "DOMAIN_NAME: ${DOMAIN_NAME}"
    echo "WP_ADMIN: ${WP_ADMIN}"
    echo "WP_ADMIN_EMAIL: ${WP_ADMIN_EMAIL}"
    exit 1
fi

# Criar usuário viewer se especificado
if [ ! -z "${WP_VIWER_USER}" ]; then
    echo "Criando usuário viewer..."
    ./wp-cli.phar user create ${WP_VIWER_USER} ${WP_VIWER_EMAIL} --user_pass=${WP_VIWER_PASSWORD} --role=subscriber --allow-root
fi

echo "Iniciando PHP-FPM..."
# Verificar se a configuração está correta
php-fpm8.2 -t
if [ $? -ne 0 ]; then
    echo "ERRO: Configuração do PHP-FPM inválida!"
    exit 1
fi

# Iniciar PHP-FPM em foreground
exec php-fpm8.2 -F