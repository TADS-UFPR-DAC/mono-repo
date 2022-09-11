#!/bin/sh
apt install docker-compose
git clone https://github.com/TADS-UFPR-DAC/gerente-service
git clone https://github.com/TADS-UFPR-DAC/conta-service
git clone https://github.com/TADS-UFPR-DAC/auth-service
git clone https://github.com/TADS-UFPR-DAC/api-gateway
git clone https://github.com/TADS-UFPR-DAC/cliente-service
cd api-gateway 
docker build -t api-gateway . 
cd ..
cd gerente-service 
mvn package -DskipTests
cd ..
cd conta-service
mvn package -DskipTests
cd ..
cd cliente-service
mvn package -DskipTests
cd ..
cd auth-service
mvn package -DskipTests
cd ..
docker-compose build
docker-compose up -d