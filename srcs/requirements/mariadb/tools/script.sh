#!/bin/bash

# Garantir permissões corretas
chown -R mysql:mysql /var/lib/mysql
chown -R mysql:mysql /run/mysqld

# Inicializar MariaDB se não foi inicializado
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Inicializando banco de dados..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Iniciar MariaDB em background
echo "Iniciando MariaDB..."
mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking --socket=/run/mysqld/mysqld.sock &
MYSQL_PID=$!

# Aguardar o MariaDB inicializar
sleep 10

# Aguardar até que o MySQL esteja acessível via socket
while ! mysqladmin ping --socket=/run/mysqld/mysqld.sock --silent; do
    echo "Aguardando MariaDB inicializar..."
    sleep 2
done

echo "MariaDB iniciado com sucesso!"

# Configurar banco de dados usando variáveis de ambiente
mysql --socket=/run/mysqld/mysqld.sock -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
mysql --socket=/run/mysqld/mysqld.sock -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mysql --socket=/run/mysqld/mysqld.sock -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"
mysql --socket=/run/mysqld/mysqld.sock -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
mysql --socket=/run/mysqld/mysqld.sock -e "FLUSH PRIVILEGES;"

echo "Banco de dados configurado com sucesso!"

# Parar o MySQL temporário
kill $MYSQL_PID
wait $MYSQL_PID

# Iniciar MariaDB normalmente para aceitar conexões de rede
echo "Iniciando MariaDB para aceitar conexões..."
exec mysqld --user=mysql --datadir=/var/lib/mysql
