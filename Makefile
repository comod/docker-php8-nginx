include .env
WEBSERVER_CONTAINER := web
DOCKER_COMPOSE := docker-compose
MAKE := make
################################################################
## Docker
################################################################

start: ## Starts the application for local development
	@$(DOCKER_COMPOSE) up --remove-orphans -d
	@$(MAKE) composer-install
	@$(MAKE) composer-dumpautoload
	@$(MAKE) -s infos

stop: ## Stop the entire docker compose stack
	@$(DOCKER_COMPOSE) stop

restart:
	@$(MAKE) -s stop || true
	@$(MAKE) -s start

bash: ## Run a shell inside the webserver container
	@$(DOCKER_COMPOSE) exec $(WEBSERVER_CONTAINER) bash

################################################################
## Info
################################################################
phpversion: ## phpversion
	@$(DOCKER_COMPOSE) exec  php php --version

infos: ## Info
	@$(MAKE) phpversion
	@echo "The App is available at http://${PROJECT_NAME}:${WEBSERVER_PORT}"

################################################################
## Logs
################################################################

logs: ## Call the logs from the entire stack, and follow them (like tail -f)
	$(DOCKER_COMPOSE) logs --follow

################################################################
## Composer
################################################################

composer-install: ## Run composer install
	$(DOCKER_COMPOSE) run --rm composer install

composer-update: ## Run composer install
	$(DOCKER_COMPOSE) run --rm composer update

composer-dumpautoload: ## Run composer dumpautoload
	$(DOCKER_COMPOSE) run --rm composer dumpautoload

phpunit:
	$(DOCKER_COMPOSE) exec php php vendor/bin/phpunit
