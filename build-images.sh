#!/bin/sh
cd api-gateway 
docker build -t api-gateway . 
cd ..
cd gerente-service 
./mvnw spring-boot:build-image
cd ..
cd conta-service
./mvnw spring-boot:build-image
cd ..
cd cliente-service
./mvnw spring-boot:build-image
cd ..
cd auth-service
./mvnw spring-boot:build-image
cd ..
