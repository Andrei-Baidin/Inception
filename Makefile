DATA_DIR := /home/nnamor/data
MYSQL_VOL := $(DATA_DIR)/mysql
WP_VOL := $(DATA_DIR)/wordpress
REDIS_VOL := $(DATA_DIR)/redis
YML := srcs/docker-compose.yml

DC := docker-compose

COMPOSE = $(DC) -f $<

#-------------------------------------------------------------------------------#

all : build

build : $(YML) | $(MYSQL_VOL) $(WP_VOL) $(REDIS_VOL)
	@$(COMPOSE) up --build --no-start

run : $(YML) | $(MYSQL_VOL) $(WP_VOL) $(REDIS_VOL)
	@$(COMPOSE) up -d

$(MYSQL_VOL) :
	@mkdir -p $@
	@chown -R gtfo:gtfo $@

$(WP_VOL) :
	@mkdir -p $@
	@chown -R gtfo:gtfo $@

$(REDIS_VOL):
	@mkdir -p $@
	@chown -R gtfo:gtfo $@

stop : $(YML)
	@$(COMPOSE) stop

restart : $(YML)
	@$(COMPOSE) restart

ps :
	@docker ps -a

df :
	@docker system df -v

clean : $(YML)
	@$(COMPOSE) down

fclean : clean
	@rm -rf $(DATA_DIR)
	@echo y | docker system prune --all --volumes

re : fclean all

help :
	@echo "build   - Build or rebuild services"
	@echo "run     - Create and start containers"
	@echo "stop    - Stop services"
	@echo "restart - Restart services"
	@echo "ps      - List containers"
	@echo "df      - Show docker disk usage"
	@echo "clean   - Stop and remove containers"
	@echo "fclean  - Remove all resources"
	@echo "re      - Remove resources and build from scratch"

.PHONY : all build run stop restart ps df clean fclean re help
