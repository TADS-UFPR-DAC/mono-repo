#!/bin/sh
git clone https://github.com/TADS-UFPR-DAC/gerente-service
git clone https://github.com/TADS-UFPR-DAC/conta-service
git clone https://github.com/TADS-UFPR-DAC/auth-service
git clone https://github.com/TADS-UFPR-DAC/api-gateway
git clone https://github.com/TADS-UFPR-DAC/cliente-service
cd api-gateway
git pull
docker build -t api-gateway .
cd ..
cd gerente-service
git pull
mvn package -DskipTests
cd ..
cd conta-service
git pull
mvn package -DskipTests
cd ..
cd cliente-service
git pull
mvn package -DskipTests
cd ..
cd auth-service
git pull
mvn package -DskipTests
cd ..
docker-compose build
docker-compose up -d
