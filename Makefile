ps:
	docker-compose ps

up:
	docker-compose up -d

logs:
	docker-compose logs -f blockchain

recreate:
	docker-compose up -d --force-recreate

rebuild:
	docker-compose up -d --force-recreate --rebuild

compile:
	docker-compose exec blockchain yarn run compile

deploy:
	docker-compose exec blockchain yarn run deploy

deploy-rinkeby:
	docker-compose exec blockchain yarn run deploy:rinkeby

node:
	docker-compose exec blockchain yarn run node

runtest:
	docker-compose exec blockchain yarn run test
