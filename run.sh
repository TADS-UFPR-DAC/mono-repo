#!/bin/sh
#---------------------------------------------- Networks -----------------------------------------------
docker network create --driver bridge bantads-network # MAIN NETWORK
docker network create --driver bridge gerente-network # GERENTE NETWORK
#---------------------------------------------- Databases ----------------------------------------------
docker run --name postgres-build-test -e POSTGRES_DB=postgres -e POSTGRES_PASSWORD=password -p 5432:5432 -d postgres #BUILD DATABASE
docker run --network gerente-network --name gerente-bd -e POSTGRES_DB=postgres -e POSTGRES_PASSWORD=password -d postgres #GERENTE DATABASE
#-------------------------------------------------------------------------------------------------------
#--------------------------------------------- API GATEWAY ---------------------------------------------
cd api-gateway
docker build -t api-gateway . #BUILD API GATEWAY IMAGE
docker run --network bantads-network --name api-gateway -p 3000:3000 -d api-gateway # DEPLOY CONTAINER
cd ..
#-------------------------------------------------------------------------------------------------------
#--------------------------------------------Gerente Service -------------------------------------------
cd gerente-service
sudo sh ./mvnw spring-boot:build-image #BUILD Gerente Service IMAGE
docker run --network gerente-network --name gerente-service -p 5002:5002 -e DATABASE_HOST=gerente-bd -d gerente-service:0.0.1-SNAPSHOT #DEPLOY CONTAINER
docker network connect bantads-network gerente-service #ATTACH MAIN NETWORK
cd ..
#-------------------------------------------------------------------------------------------------------
