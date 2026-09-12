NAME = inception

FILE = srcs/docker-compose.yml
FILE_BONUS = srcs/docker-compose-bonus.yml
ALL_FILE = -f $(FILE) -f $(FILE_BONUS)
DATA_PATH = /home/eprieur/data

all:
	@mkdir -p $(DATA_PATH)/mariadb $(DATA_PATH)/wordpress
	docker compose -f $(FILE) up --build

down:
	docker compose $(ALL_FILE) down

stop:
	docker compose $(ALL_FILE) stop

clean: down
	@sudo rm -rf $(DATA_PATH)/mariadb/* $(DATA_PATH)/wordpress/* $(DATA_PATH)/nginx/* $(DATA_PATH)/adminer/*

bonus:
	@mkdir -p $(DATA_PATH)/mariadb $(DATA_PATH)/wordpress $(DATA_PATH)/adminer
	docker compose $(ALL_FILE) up --build

fclean: clean
	@sudo rm -rf $(DATA_PATH)/mariadb/* $(DATA_PATH)/wordpress/* $(DATA_PATH)/nginx/*
	@sudo rm -rf $(DATA_PATH)/adminer/*
	docker system prune -a --volumes -f
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true

re: fclean all

.PHONY: all down stop bonus clean fclean re