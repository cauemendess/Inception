# Inception
# EVALUATION GUIDE

## Basic Setup Verification
```bash
docker network ls
docker ps
docker volume ls
```

## Docker Compose Compliance
```bash
grep -E 'network: host|links:' ./srcs/docker-compose.yml  # Should be empty
grep 'networks:' ./srcs/docker-compose.yml                # Should exist
grep -r '^FROM' ./srcs                                    # Must be Alpine/Debian only
```

## Security & Configuration
```bash
grep -r --include=\*.sh --include=Makefile -E 'tail -f|sleep infinity|--link|nginx \&|bash' .
grep -r --include=\*.sh --include=\*.yml -E "latest|password.*=" .
```

## HTTPS/TLS Testing
Open on Firefox https://csilva-m.42.fr

## Container Access & Testing
```bash
docker exec -it mariadb mysql -u wp_user -p
docker exec -it nginx nginx -t
docker exec -it wordpress ls -la /var/www/html
docker exec -it wordpress php -v
```

## Persistence Testing
```bash
docker exec -it mariadb mysql -u wp_user -p -e "CREATE TABLE test_table (id INT);" wordpress
docker restart mariadb
docker exec -it mariadb mysql -u wp_user -p -e "SHOW TABLES;" wordpress  # Should persist
```

## Restart Behavior
```bash
docker exec -it mariadb pkill -9 mysqld  # Kill main process inside container
docker ps  # Should show auto-restart
```

## Cleanup Verification
```bash
make fclean
docker ps -a && docker images && docker volume ls && docker network ls  # Should be clean
ls /home/csilva-m/data # Should be empty
```

## Inside MariaDB:
To access MariaDB:
```bash
docker exec -it mariadb mysql -u wp_user -p
```

```bash
SHOW DATABASES;
USE wordpress;
SHOW TABLES;
SELECT * FROM wp_users;
DESCRIBE wp_posts;
```