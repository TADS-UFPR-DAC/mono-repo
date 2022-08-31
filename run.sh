#!/bin/sh
docker network create --driver bridge gerente-network
docker run  --name postgres-build-test -e POSTGRES_DB=postgres -e POSTGRES_PASSWORD=password -p 5432:5432 -d postgres
docker run --network gerente-network --name services-bd -e POSTGRES_DB=postgres -e POSTGRES_PASSWORD=password -p 5432: -d postgres
cd gerente-service
sudo sh ./mvnw spring-boot:build-image
docker run --network gerente-network --name gerente-service -p 5002:5002 -e DATABASE_HOST=gerente-bd -d gerente-service:0.0.1-SNAPSHOT