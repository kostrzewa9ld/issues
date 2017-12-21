#!/usr/bin/env bash

export DOCKER_HOST= #10.9.4.172
docker network create -d overlay --attachable my_net
docker service create --name postgres1 --health-cmd "pg_isready --host localhost" --health-interval=10s --health-timeout=5s --health-retries=30 --network my_net postgres
docker service create --name postgres2 --health-cmd "pg_isready --host localhost" --health-interval=10s --health-timeout=5s --health-retries=30 --network my_net postgres
docker service create --name postgres3 --health-cmd "pg_isready --host localhost" --health-interval=10s --health-timeout=5s --health-retries=30 --network my_net postgres
