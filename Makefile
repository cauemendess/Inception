all: up

setup:
	@echo "📁 Creating necessary directories..."
	@if ! grep -q "^127\.0\.0\.1.*\bcsilva-m\.42\.fr\b" /etc/hosts; then \
		echo "Adicionando csilva-m.42.fr ao /etc/hosts..."; \
		echo "127.0.0.1 csilva-m.42.fr" | sudo tee -a /etc/hosts > /dev/null; \
	else \
		echo "csilva-m.42.fr já está presente no /etc/hosts."; \
	fi
	@sudo mkdir -p /home/csilva-m/data/wordpress
	@sudo mkdir -p /home/csilva-m/data/mariadb
	@sudo chown -R $(USER):$(USER) /home/csilva-m/data
	@echo "Directories created!"

up: setup
	@docker-compose -f ./srcs/docker-compose.yml up -d

down:
	@docker-compose -f ./srcs/docker-compose.yml down

stop:
	@docker-compose -f ./srcs/docker-compose.yml stop

start:
	@docker-compose -f ./srcs/docker-compose.yml start

restart:
	@echo "🔄 Restarting containers..."
	@docker-compose -f ./srcs/docker-compose.yml restart

rebuild:
	@echo "🔄 Rebuilding containers..."
	@docker-compose -f ./srcs/docker-compose.yml down
	@docker-compose -f ./srcs/docker-compose.yml up -d --build


reset:
	@echo "🧹 Resetting everything..."
	@docker-compose -f ./srcs/docker-compose.yml down
	@docker system prune -af --volumes
	@docker-compose -f ./srcs/docker-compose.yml up -d --build

clean:
	@echo "🗑️ Cleaning project containers and images..."
	@docker-compose -f ./srcs/docker-compose.yml down -v
	@docker rmi -f $$(docker images -q srcs-*) 2>/dev/null || true
	@docker system prune -f
	@docker volume prune -f
	@echo "🗂️ Cleaning host data directories..."
	@sudo rm -rf /home/csilva-m/data/wordpress 2>/dev/null || true
	@sudo rm -rf /home/csilva-m/data/mariadb 2>/dev/null || true
	@echo "Host data cleaned!"

fclean:
	@echo "💥 Full clean - removing everything..."
	@docker-compose -f ./srcs/docker-compose.yml down -v 2>/dev/null || true
	@docker stop $$(docker ps -qa) 2>/dev/null || true
	@docker rm $$(docker ps -qa) 2>/dev/null || true
	@docker rmi -f $$(docker images -qa) 2>/dev/null || true
	@docker system prune -af --volumes
	@docker volume prune -f
	@echo "🗂️ Cleaning host data directories..."
	@sudo rm -rf /home/csilva-m/data 2>/dev/null || true
	@echo "Host data cleaned!"


status:
	@docker ps -a

logs:
	@docker-compose -f ./srcs/docker-compose.yml logs -f

logs-%:
	@docker logs -f $*

.PHONY: all setup up down stop start restart rebuild reset clean fclean status logs