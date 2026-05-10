NAME = inception
DOCKER_COMPOSE = docker compose -f srcs/docker-compose.yml
DATA_PATH = /home/lgracia-/data

all:
	@mkdir -p $(DATA_PATH)/mariadb
	@mkdir -p $(DATA_PATH)/wordpress
	$(DOCKER_COMPOSE) up -d --build

down:
	$(DOCKER_COMPOSE) down

clean:
	$(DOCKER_COMPOSE) down -v --rmi all
	@rm -rf $(DATA_PATH)

re: clean all

.PHONY: all build down clean re