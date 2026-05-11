NAME = inception
DOCKER_COMPOSE = docker-compose -f srcs/docker-compose.yml
DATA_PATH = /home/lgracia-/data

all:
	@mkdir -p $(DATA_PATH)/mariadb
	@mkdir -p $(DATA_PATH)/wordpress
	$(DOCKER_COMPOSE) up -d --build

clean:
	docker run --rm -v $(DATA_PATH):/data alpine:3.22 sh -c "rm -rf /data/*"
	$(DOCKER_COMPOSE) down -v --rmi all

fclean: clean
	docker system prune -af
	docker volume prune -f

prune: fclean
	docker builder prune -af

re: fclean all

.PHONY: all clean fclean prune re