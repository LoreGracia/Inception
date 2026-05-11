NAME = inception
DOCKER_COMPOSE = docker-compose -f srcs/docker-compose.yml
DATA_PATH = /home/lgracia-/data

all:
	@mkdir -p $(DATA_PATH)/mariadb
	@mkdir -p $(DATA_PATH)/wordpress
	$(DOCKER_COMPOSE) up -d --build

clean:
	$(DOCKER_COMPOSE) down -v --rmi all
	@rm -rf $(DATA_PATH)

fclean: clean
	docker system prune -af
	docker volume prune -f

prune: fclean
	docker builder prune -af

re: fclean all

.PHONY: all clean fclean prune re