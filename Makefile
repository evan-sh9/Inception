NAME = inception

FILE = srcs/docker-compose.yml
DATA_PATH = /home/eprieur/data

all: setup up

setup:
	@mkdir -p $(DATA_PATH)/mariadb
	@mkdir -p $(DATA_PATH)/wordpress
	@mkdir -p $(DATA_PATH)/nginx

up: setup
	docker compose -f $(FILE) up --build

down:
	docker compose -f $(FILE) down

start:
	docker compose -f $(FILE) start

stop:
	docker compose -f $(FILE) stop

clean: down
	docker system prune -a -f

fclean: clean
	@if [ -d "$(DATA_PATH)" ]; then sudo rm -rf $(DATA_PATH)/mariadb/* $(DATA_PATH)/wordpress/* $(DATA_PATH)/nginx/*; fi
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true

re: fclean all

.PHONY: all setup up down start stop clean fclean re