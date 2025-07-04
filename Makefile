all: up

up:
	@docker-compose -f ./srcs/docker-compose.yml up -d

down:
	@docker-compose -f ./srcs/docker-compose.yml down

stop:
	@docker-compose -f ./srcs/docker-compose.yml stop

start:
	@docker-compose -f ./srcs/docker-compose.yml start

# Rebuild - reconstrói as imagens e sobe os containers
rebuild:
	@echo "🔄 Rebuilding containers..."
	@docker-compose -f ./srcs/docker-compose.yml down
	@docker-compose -f ./srcs/docker-compose.yml up -d --build

# Reset - para tudo, remove containers e imagens, reconstrói do zero
reset:
	@echo "🧹 Resetting everything..."
	@docker-compose -f ./srcs/docker-compose.yml down
	@docker system prune -af --volumes
	@docker-compose -f ./srcs/docker-compose.yml up -d --build

# Clean - remove tudo relacionado ao projeto
clean:
	@echo "🗑️ Cleaning project containers and images..."
	@docker-compose -f ./srcs/docker-compose.yml down -v
	@docker rmi -f $$(docker images -q srcs-*) 2>/dev/null || true
	@docker system prune -f
	@docker volume prune -f
	@echo "🗂️ Cleaning host data directories..."
	@sudo rm -rf /home/csilva-m/data/wordpress 2>/dev/null || true
	@echo "Host data cleaned!"

# Fclean - limpeza completa do sistema Docker
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

# Clean-data - remove apenas os dados do host
clean-data:
	@echo "🗂️ Cleaning host data directories only..."
	@sudo rm -rf /home/csilva-m/data/wordpress 2>/dev/null || true
	@echo "Host data directories cleaned!"

status:
	@docker ps -a

# Logs - mostra os logs dos containers
logs:
	@docker-compose -f ./srcs/docker-compose.yml logs -f

# Logs de um container específico (use: make logs-nginx)
logs-%:
	@docker logs -f $*

.PHONY: all up down stop start rebuild reset clean clean-data fclean status logs