#!/bin/sh
git clone https://github.com/TADS-UFPR-DAC/gerente-service
git clone https://github.com/TADS-UFPR-DAC/conta-service
git clone https://github.com/TADS-UFPR-DAC/auth-service
git clone https://github.com/TADS-UFPR-DAC/api-gateway
git clone https://github.com/TADS-UFPR-DAC/cliente-service
#---------------------------------------------- Networks -----------------------------------------------
docker network create --driver bridge bantads-network # MAIN NETWORK
docker network create --driver bridge conta-network # CONTA NETWORK
docker network create --driver bridge cliente-network # CLIENTE NETWORK
docker network create --driver bridge gerente-network # GERENTE NETWORK
docker network create --driver bridge auth-network # AUTH NETWORK
#----------------------------------------------  RABBITMQ ----------------------------------------------
docker run --network bantads-network -p 15672:15672 -p 5672:5672 --name rabbit -d rabbitmq:3-management
#---------------------------------------------- Databases ----------------------------------------------
docker run --name postgres-build-test -e POSTGRES_DB=postgres -e POSTGRES_PASSWORD=password -p 5432:5432 -d postgres #BUILD DATABASE
docker run --network conta-network --name conta-bd-read -e POSTGRES_DB=read -e POSTGRES_PASSWORD=password -d postgres #CONTA DATABASE READ
docker run --network conta-network --name conta-bd-create -e POSTGRES_DB=create -e POSTGRES_PASSWORD=password -d postgres #CONTA DATABASE CREATE
docker run --network cliente-network --name cliente-bd -e POSTGRES_DB=postgres -e POSTGRES_PASSWORD=password -d postgres #GERENTE DATABASE
docker run --network gerente-network --name gerente-bd -e POSTGRES_DB=postgres -e POSTGRES_PASSWORD=password -d postgres #GERENTE DATABASE
docker run --network auth-network --name auth-bd -e POSTGRES_DB=postgres -e POSTGRES_PASSWORD=password -d postgres #AUTH DATABASE
#-------------------------------------------------------------------------------------------------------
#--------------------------------------------- API GATEWAY ---------------------------------------------
cd api-gateway
docker build -t api-gateway . #BUILD API GATEWAY IMAGE
docker run --network bantads-network --name api-gateway -p 3000:3000 -d api-gateway # DEPLOY CONTAINER
cd ..
#-------------------------------------------------------------------------------------------------------
#-------------------------------------------- Conta Service --------------------------------------------
cd conta-service
./mvnw spring-boot:build-image #BUILD Conta Service IMAGE
docker run --network conta-network --name conta-service -p 5000:5000 -e DATABASE_HOST=conta-bd-read -e SECOND_DATABASE_HOST=conta-bd-create -d conta-service:0.0.1-SNAPSHOT #DEPLOY CONTAINER
docker network connect bantads-network conta-service #ATTACH MAIN NETWORK
cd ..
#-------------------------------------------------------------------------------------------------------
#-------------------------------------------- Cliente Service --------------------------------------------
cd cliente-service
./mvnw spring-boot:build-image #BUILD Conta Service IMAGE
docker run --network cliente-network --name cliente-service -p 5001:5001 -e DATABASE_HOST=cliente-bd -d cliente-service:0.0.1-SNAPSHOT #DEPLOY CONTAINER
docker network connect bantads-network cliente-service #ATTACH MAIN NETWORK
cd ..
#-------------------------------------------------------------------------------------------------------
#-------------------------------------------- Gerente Service ------------------------------------------
cd gerente-service
./mvnw spring-boot:build-image #BUILD Gerente Service IMAGE
docker run --network gerente-network --name gerente-service -p 5002:5002 -e DATABASE_HOST=gerente-db -d gerente-service:0.0.1-SNAPSHOT #DEPLOY CONTAINER
docker network connect bantads-network gerente-service #ATTACH MAIN NETWORK
cd ..
#-------------------------------------------------------------------------------------------------------
#-------------------------------------------- Auth Service --------------------------------------------
cd auth-service
./mvnw spring-boot:build-image #BUILD Auth Service IMAGE
docker run --network auth-network --name auth-service -p 5003:5003 -e DATABASE_HOST=auth-bd -d auth-service:0.0.1-SNAPSHOT #DEPLOY CONTAINER
docker network connect bantads-network auth-service #ATTACH MAIN NETWORK
cd ..
#-------------------------------------------------------------------------------------------------------

docker container ls #LIST CONTAINERS
